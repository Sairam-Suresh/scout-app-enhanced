import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:quiver/iterables.dart' show partition;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/database_provider/scout_db_provider.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badge_scraping_progress_provider.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:uuid/uuid.dart';

part 'scout_badges_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutBadgesNotifier extends _$ScoutBadgesNotifier {
  AppDatabase? db;

  @override
  FutureOr<List<ScoutBadgeItem>> build() async {
    db = ref.read(databaseProvider);

    return db!.select(db!.scoutBadgeItems).get();
  }

  Future<ScoutBadgeItem> obtainBadgeByName(String name) async {
    return await (db!.select(db!.scoutBadgeItems)
          ..where((tbl) => tbl.name.equals(name))
          ..limit(1))
        .getSingle();
  }

  Future<void> toggleBadgeLikeStatusByUuid(String uuid) async {
    var badgeToModify = await (db!.select(db!.scoutBadgeItems)
          ..where((tbl) => tbl.uuid.equals(uuid))
          ..limit(1))
        .getSingle();

    var numberOfModifiedRows = await (db!.update(db!.scoutBadgeItems)
          ..where((t) => t.uuid.equals(uuid)))
        .write(
      ScoutBadgeItemsCompanion(
        isLiked: Value(!badgeToModify.isLiked),
      ),
    );

    if (numberOfModifiedRows != 1) {
      throw Exception(
          "WARNING: More than one row was affected when the liked status of a badge was toggled.");
    }

    ref.invalidateSelf();
  }

  Future<void> scrapeScoutsWebsiteAndUpdateDb() async {
    ref
        .read(scoutBadgeScrapingProgressProvider.notifier)
        .arm(BadgeScrapingMedium.scoutsWebsite);
    ref
        .read(scoutBadgeScrapingProgressProvider.notifier)
        .markDownloadAs(BadgeScrapingStatus.starting);

    List<String> parsedUrls = [];
    var firstGetAllBadgesCompleter = Completer();

    var headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse("https://app.scout.sg/#/scouts/scouts_gridview/scouts"),
      ),
      onLoadStop: (controller, url) {
        firstGetAllBadgesCompleter.complete();
      },
      onLoadError: (headlessWebView, url, code, message) {
        return;
      },
    );

    await headlessWebView.run();

    await firstGetAllBadgesCompleter.future;

    var urlsObtained =
        await headlessWebView.webViewController.evaluateJavascript(source: """
              JSON.stringify(
                Array.from(document.getElementsByTagName('a'))
                  .map(img => img.href)
              )
              """);
    parsedUrls = List<String>.from(jsonDecode(urlsObtained));

    await headlessWebView.dispose();
    // Filter out the garbage
    parsedUrls.removeWhere((element) =>
        element == "https://scout.sg/" ||
        element == "http://intranet.scout.org.sg/");

    List<String>? alreadyParsedUrlsFromDb =
        state.asData?.value.map((e) => e.url).toList();

    if (alreadyParsedUrlsFromDb != null) {
      parsedUrls.removeWhere((element) => alreadyParsedUrlsFromDb.contains(
          element)); // Remove all the urls that have been parsed already.
    }

    if (parsedUrls.isEmpty) {
      // If there are no parsedUrls, then there is nothing to be done
      ref.read(scoutBadgeScrapingProgressProvider.notifier).completed();
      return;
    }

    ref
        .read(scoutBadgeScrapingProgressProvider.notifier)
        .initialiseTotal(totalToParse: parsedUrls.length);

    ref
        .read(scoutBadgeScrapingProgressProvider.notifier)
        .markDownloadAs(BadgeScrapingStatus.downloading);

    var splitUrls = partition(parsedUrls, 2).toList();

    for (List<String> i in splitUrls) {
      for (ScoutBadgeItemsCompanion badge
          in (await Future.wait(i.map((e) => _parseScoutDataUrl(e))))) {
        var dbUpdateAttempts = 0;

        while (true) {
          try {
            db!.into(db!.scoutBadgeItems).insert(badge);
            ref.read(scoutBadgeScrapingProgressProvider.notifier).parsedOne();
            ref.invalidateSelf();
            dbUpdateAttempts++;
            break;
          } catch (e) {
            if (dbUpdateAttempts <= 3) {
              await Future.delayed(const Duration(seconds: 1));
              continue;
            } else {
              throw Exception(
                  "Took more than 3 attempts to try to update the database");
            }
          }
        }
      }
    }

    ref
        .read(scoutBadgeScrapingProgressProvider.notifier)
        .markDownloadAs(BadgeScrapingStatus.completed);

    ref.read(scoutBadgeScrapingProgressProvider.notifier).completed();
  }

  Future<ScoutBadgeItemsCompanion> _parseScoutDataUrl(String i) async {
    var waitForLoadComplete = Completer();
    InAppWebViewController? controller;

    HeadlessInAppWebView tempView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(i)),
        onLoadStop: (webController, url) {
          webController.scrollBy(x: 100, y: 100);
          controller = webController;
          waitForLoadComplete.complete();
        });

    await tempView.run();

    await waitForLoadComplete.future;

    var image = "[\"\"]";
    var name = "[\"\"]";
    var desc = "[]";

    while (image == "[\"\"]" ||
        name == "[\"\"]" ||
        desc == "[]" ||
        image == "" ||
        name == "" ||
        desc == "") {
      try {
        image = await tempView.webViewController.evaluateJavascript(source: """
                JSON.stringify(
                Array.from(document.getElementsByTagName('img'))
                  .map(img => img.src)
              )
              """);

        name = await tempView.webViewController.evaluateJavascript(source: """
              JSON.stringify(
              Array.from(document.getElementsByTagName('h2'))
                .map(h2 => h2.textContent)
            )
              """);

        desc = await tempView.webViewController.evaluateJavascript(source: """
    const spanElement = document.querySelector('span.ng-binding'); 
    
    const elementsInsideSpan = Array.from(spanElement.childNodes);
    
    const contentArray = elementsInsideSpan.map(node => {
      if (node.nodeType === Node.TEXT_NODE) {
        return node.textContent.trim();
      } else if (node.nodeType === Node.ELEMENT_NODE) {
        return node.outerHTML;
      }
    });
    
    JSON.stringify(contentArray);
    
    """);
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 1000));
        await controller?.reload();
        continue;
      }
    }

    String imageURL = List<String>.from(jsonDecode(image))[0];
    String badgeName = List<String>.from(jsonDecode(name))[0];
    String description = List<String>.from(jsonDecode(desc)).join("");

    if (imageURL == "" || badgeName == "" || description == "") {
      throw Exception("Some Fields are empty!");
    }

    var newBadge = ScoutBadgeItemsCompanion(
      uuid: Value(const Uuid().v4().toString()),
      url: Value(i),
      name: Value(badgeName),
      imageUrl: Value(imageURL),
      description: Value(description),
    );

    tempView.dispose();
    return newBadge;
  }
}
