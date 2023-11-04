// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../database.dart';

class ScoutReflectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get scoutBadges => text().check(scoutBadges.isNotValue(""))();
  TextColumn get title => text().check(title.isNotValue(""))();
  TextColumn get content => text().check(content.isNotValue(""))();

  DateTimeColumn get creationDate =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastEditDate =>
      dateTime().withDefault(currentDateAndTime)();
}

extension ObtainAssociatedBadgeIDList on ScoutReflectionItem {
  List<int> get scoutBadgesList =>
      scoutBadges.split(",").map((e) => int.parse(e)).toList();
}
