import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scout_badge_scraping_progress_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutBadgeScrapingProgress extends _$ScoutBadgeScrapingProgress {
  @override
  ({int parsed, int remaining, int? total})? build() {
    return null;
  }

  void arm() {
    state = (parsed: 0, remaining: 0, total: null);
  }

  void initialiseTotal({required int totalToParse}) {
    state = (parsed: 0, remaining: totalToParse, total: totalToParse);
  }

  void parsedOne() {
    if (state == null) {
      throw Exception(
          "The Progress has not been initialised. The initialiseTotal Function needs to be used before calling this.");
    }
    state = (
      parsed: state!.parsed + 1,
      remaining: state!.remaining - 1,
      total: state!.total
    );
  }

  void completed() {
    state = null;
  }
}
