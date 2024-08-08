part '../../parts/general_parts/bank_name.dart';

class BankName {
  String? code;
  String? name;

  BankName({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$BankNameFromJson(json);

  factory BankName.fromJson(Map<String, dynamic> json) =>
      _$BankNameFromJson(json);
  Map<String, dynamic> toJson() => _$BankNameToJson(this);
}
