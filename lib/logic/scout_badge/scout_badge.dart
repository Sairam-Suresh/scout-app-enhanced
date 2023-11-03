import 'package:freezed_annotation/freezed_annotation.dart';

part 'scout_badge.freezed.dart';
part 'scout_badge.g.dart';

@freezed
class ScoutBadge with _$ScoutBadge {
  factory ScoutBadge({
    required String url,
    required String name,
    required String description,
    required String imageUrl,
    required bool parsedGoogleSheetInfo,
    required String completed,
    required String badgeGiven,
    required String certGiven,
  }) = _ScoutBadge;

  factory ScoutBadge.fromJson(Map<String, dynamic> json) =>
      _$ScoutBadgeFromJson(json);
}
