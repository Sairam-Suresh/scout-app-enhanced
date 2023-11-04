import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:scout_app_enhanced/logic/scout_badge_storage/tables/scout_badge_table.dart';
import 'package:scout_app_enhanced/logic/scout_badge_storage/tables/scout_notes_table.dart';
import 'package:scout_app_enhanced/logic/scout_badge_storage/tables/scout_reflections_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ScoutBadgeItems, ScoutNoteItems, ScoutReflectionItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'scout_badge_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
