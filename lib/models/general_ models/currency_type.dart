part '../../parts/general_parts/currency_type.dart';

class CurrencyType {
  String? code;
  String? name;

  CurrencyType({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$CurrencyTypeFromJson(json);

  factory CurrencyType.fromJson(Map<String, dynamic> json) =>
      _$CurrencyTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyTypeToJson(this);
}
