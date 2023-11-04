import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';

part 'scout_notes_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoutNotesNotifier extends _$ScoutNotesNotifier {
  final database = AppDatabase();

  @override
  FutureOr<List<ScoutNoteItem>> build() async {
    return database.select(database.scoutNoteItems).get();
  }
}
