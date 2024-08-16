part of '../../models/general_ models/amount_range.dart';

AmountRange _$AmountRangeFromJson(Map<String, dynamic> json) {
  return AmountRange(
    code: json['code'] != null ? json['code'] as String : null,
    value: json['value'] != null ? json['value'] as num : null,
  );
}

Map<String, dynamic> _$AmountRangeToJson(AmountRange instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.value != null) json['value'] = instance.value;

  return json;
}
