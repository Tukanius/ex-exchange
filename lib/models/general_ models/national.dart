part '../../parts/general_parts/national.dart';

class National {
  String? code;
  String? name;

  National({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$NationalFromJson(json);

  factory National.fromJson(Map<String, dynamic> json) =>
      _$NationalFromJson(json);
  Map<String, dynamic> toJson() => _$NationalToJson(this);
}
