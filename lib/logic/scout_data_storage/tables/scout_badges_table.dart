// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:scout_app_enhanced/logic/scout_data_storage/database.dart';
import 'package:uuid/uuid.dart';

class ScoutBadgeItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid =>
      text().unique().withDefault(Constant(const Uuid().v1().toString()))();

  TextColumn get url => text().check(url.isNotValue(""))();
  TextColumn get name => text().check(name.isNotValue(""))();
  TextColumn get description => text().check(description.isNotValue(""))();
  TextColumn get imageUrl => text().check(imageUrl.isNotValue(""))();

  TextColumn get completed => text().nullable()();
  TextColumn get badgeGiven => text().nullable()();
  TextColumn get certGiven => text().nullable()();
}

extension ParsedFromSourcesExtension on ScoutBadgeItem {
  bool get parsedInfoFromGSheets =>
      (completed != null && badgeGiven != null && certGiven != null);
}
