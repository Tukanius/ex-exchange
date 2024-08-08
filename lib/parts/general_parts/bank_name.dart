part of '../../models/general_ models/bank_name.dart';

BankName _$BankNameFromJson(Map<String, dynamic> json) {
  return BankName(
    code: json['code'] != null ? json['code'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
  );
}

Map<String, dynamic> _$BankNameToJson(BankName instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;

  return json;
}
