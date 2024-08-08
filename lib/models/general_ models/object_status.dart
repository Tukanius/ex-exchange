part '../../parts/general_parts/object_status.dart';

class ObjectStatus {
  String? code;
  String? name;

  ObjectStatus({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$ObjectStatusFromJson(json);

  factory ObjectStatus.fromJson(Map<String, dynamic> json) =>
      _$ObjectStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ObjectStatusToJson(this);
}
