import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';

part 'scout_reflections_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutReflectionsNotifier extends _$ScoutReflectionsNotifier {
  final database = AppDatabase();

  @override
  FutureOr<List<ScoutReflectionItem>> build() async {
    return database.select(database.scoutReflectionItems).get();
  }
}
