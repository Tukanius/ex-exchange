part '../../parts/general_parts/bank_name.dart';

class BankNames {
  String? code;
  String? name;

  BankNames({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$BankNamesFromJson(json);

  factory BankNames.fromJson(Map<String, dynamic> json) =>
      _$BankNamesFromJson(json);
  Map<String, dynamic> toJson() => _$BankNamesToJson(this);
}
