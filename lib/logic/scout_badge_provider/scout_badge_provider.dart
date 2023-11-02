import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scout_badge_provider.g.dart';

@Riverpod()
class ScoutBadgeNotifier extends _$ScoutBadgeNotifier {
  @override
  FutureOr<String> build() async {
    return "hello";
  }
}
