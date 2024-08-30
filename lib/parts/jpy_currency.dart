part of '../models/jpy_currency.dart';

JpyCurrency _$JpyCurrencyFromJson(Map<String, dynamic> json) {
  return JpyCurrency(
    type: json['type'] != null ? json['type'] as String : null,
    currency: json['currency'] != null ? json['currency'] as String : null,
    get: json['get'] != null ? json['get'] as num : null,
    sell: json['sell'] != null ? json['sell'] as num : null,
    minLimit: json['minLimit'] != null ? json['minLimit'] as num : null,
    maxLimit: json['maxLimit'] != null ? json['maxLimit'] as num : null,
    getType: json['getType'] != null ? json['getType'] as String : null,
  );
}

Map<String, dynamic> _$JpyCurrencyToJson(JpyCurrency instance) {
  Map<String, dynamic> json = {};
  if (instance.type != null) json['type'] = instance.type;
  if (instance.currency != null) json['currency'] = instance.currency;
  if (instance.get != null) json['get'] = instance.get;
  if (instance.sell != null) json['sell'] = instance.sell;
  if (instance.minLimit != null) json['minLimit'] = instance.minLimit;
  if (instance.maxLimit != null) json['maxLimit'] = instance.maxLimit;
  if (instance.getType != null) json['getType'] = instance.getType;

  return json;
}
