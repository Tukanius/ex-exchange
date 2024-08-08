part '../../parts/general_parts/user_type.dart';

class UserType {
  String? code;
  String? name;

  UserType({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$UserTypeFromJson(json);

  factory UserType.fromJson(Map<String, dynamic> json) =>
      _$UserTypeFromJson(json);
  Map<String, dynamic> toJson() => _$UserTypeToJson(this);
}
