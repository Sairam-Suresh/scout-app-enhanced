import 'package:drift/drift.dart';

class ScoutBadgeItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get url => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get imageUrl => text()();
  BoolColumn get parsedGoogleSheetInfo => boolean()();
  TextColumn get completed => text()();
  TextColumn get badgeGiven => text()();
  TextColumn get certGiven => text()();
}
