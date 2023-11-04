import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';

part 'scout_badges_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutBadgesNotifier extends _$ScoutBadgesNotifier {
  final database = AppDatabase();

  @override
  FutureOr<List<ScoutBadgeItem>> build() async {
    return database.select(database.scoutBadgeItems).get();
  }
}
