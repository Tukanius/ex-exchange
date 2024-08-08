part of '../../models/general_ models/currency_type.dart';

CurrencyType _$CurrencyTypeFromJson(Map<String, dynamic> json) {
  return CurrencyType(
    code: json['code'] != null ? json['code'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
  );
}

Map<String, dynamic> _$CurrencyTypeToJson(CurrencyType instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;

  return json;
}
