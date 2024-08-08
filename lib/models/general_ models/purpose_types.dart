part '../../parts/general_parts/purpose_types.dart';

class PurposeTypes {
  String? code;
  String? name;

  PurposeTypes({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$PurposeTypesFromJson(json);

  factory PurposeTypes.fromJson(Map<String, dynamic> json) =>
      _$PurposeTypesFromJson(json);
  Map<String, dynamic> toJson() => _$PurposeTypesToJson(this);
}
