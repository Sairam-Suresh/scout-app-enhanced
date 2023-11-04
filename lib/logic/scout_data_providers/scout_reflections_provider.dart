import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:scout_app_enhanced/logic/scout_db_provider.dart';

part 'scout_reflections_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutReflectionsNotifier extends _$ScoutReflectionsNotifier {
  AppDatabase? db;

  @override
  FutureOr<List<ScoutReflectionItem>> build() async {
    db = ref.read(databaseProvider);

    return db!.select(db!.scoutReflectionItems).get();
  }
}
