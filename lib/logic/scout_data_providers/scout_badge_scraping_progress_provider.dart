import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scout_badge_scraping_progress_provider.g.dart';

enum BadgeScrapingMedium { scoutsWebsite, googleSheets }

enum BadgeScrapingStatus { starting, downloading, completed }

class BadgeScrapingProgress {
  BadgeScrapingMedium medium;
  BadgeScrapingStatus status;
  ({int parsed, int remaining, int total})? progress;

  BadgeScrapingProgress(
      {required this.medium, required this.status, this.progress});
}

@Riverpod(keepAlive: true)
class ScoutBadgeScrapingProgress extends _$ScoutBadgeScrapingProgress {
  @override
  BadgeScrapingProgress? build() {
    return null;
  }

  void arm(BadgeScrapingMedium medium) {
    // state = (parsed: 0, remaining: 0, total: null);
    state = BadgeScrapingProgress(
        medium: medium, status: BadgeScrapingStatus.starting);
  }

  void initialiseTotal({required int totalToParse}) {
    state = BadgeScrapingProgress(
        medium: state!.medium,
        status: state!.status,
        progress: (parsed: 0, remaining: totalToParse, total: totalToParse));
  }

  void markDownloadAs(BadgeScrapingStatus status) {
    state = BadgeScrapingProgress(
        medium: state!.medium, status: status, progress: state!.progress);
  }

  void parsedOne() {
    if (state == null) {
      throw Exception(
          "The Progress has not been initialised. The initialiseTotal Function needs to be used before calling this.");
    }
    state = BadgeScrapingProgress(
        medium: state!.medium,
        status: state!.status,
        progress: (
          parsed: state!.progress!.parsed + 1,
          remaining: state!.progress!.remaining - 1,
          total: state!.progress!.total
        ));
  }

  void completed() {
    state = null;
  }
}
