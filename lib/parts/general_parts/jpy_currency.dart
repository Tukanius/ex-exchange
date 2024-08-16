part of '../../models/general_ models/jpy_currency.dart';

JpyCurrency _$JpyCurrencyFromJson(Map<String, dynamic> json) {
  return JpyCurrency(
    get: json['get'] != null ? json['get'] as num : null,
    sell: json['sell'] != null ? json['sell'] as num : null,
  );
}

Map<String, dynamic> _$JpyCurrencyToJson(JpyCurrency instance) {
  Map<String, dynamic> json = {};

  if (instance.get != null) json['get'] = instance.get;
  if (instance.sell != null) json['sell'] = instance.sell;

  return json;
}
