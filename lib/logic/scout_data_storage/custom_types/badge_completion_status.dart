import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge_completion_status.g.dart';

@JsonSerializable()
class BadgeCompletionStatus {
  bool isCompleted;

  String completedDate;
  String badgeGivenDate;
  String? certGivenDate;

  BadgeCompletionStatus(this.isCompleted, this.completedDate,
      this.badgeGivenDate, this.certGivenDate);

  factory BadgeCompletionStatus.fromJson(Map<String, dynamic> json) =>
      _$BadgeCompletionStatusFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeCompletionStatusToJson(this);
}

TypeConverter<BadgeCompletionStatus, String> badgeCompletionStatusConverter =
    TypeConverter.json(
  fromJson: (json) =>
      BadgeCompletionStatus.fromJson(json as Map<String, Object?>),
  toJson: (completionStatus) => completionStatus.toJson(),
);
