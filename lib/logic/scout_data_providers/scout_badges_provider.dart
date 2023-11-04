import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:scout_app_enhanced/logic/scout_db_provider.dart';

part 'scout_badges_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutBadgesNotifier extends _$ScoutBadgesNotifier {
  AppDatabase? db;

  @override
  FutureOr<List<ScoutBadgeItem>> build() async {
    db = ref.read(databaseProvider);

    return db!.select(db!.scoutBadgeItems).get();
  }
}
