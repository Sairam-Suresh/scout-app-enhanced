// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../custom_types/badge_completion_status.dart';

class ScoutBadgeItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid =>
      text().unique().withDefault(Constant(const Uuid().v1().toString()))();

  TextColumn get url => text().check(url.isNotValue(""))();
  TextColumn get name => text().check(name.isNotValue(""))();
  TextColumn get description => text().check(description.isNotValue(""))();
  TextColumn get imageUrl => text().check(imageUrl.isNotValue(""))();

  TextColumn get status =>
      text().map(badgeCompletionStatusConverter).nullable()();
}
