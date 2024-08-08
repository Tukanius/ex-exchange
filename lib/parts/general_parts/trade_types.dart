part of '../../models/general_ models/trade_types.dart';

TradeTypes _$TradeTypesFromJson(Map<String, dynamic> json) {
  return TradeTypes(
    code: json['code'] != null ? json['code'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
  );
}

Map<String, dynamic> _$TradeTypesToJson(TradeTypes instance) {
  Map<String, dynamic> json = {};

  if (instance.code != null) json['code'] = instance.code;
  if (instance.name != null) json['name'] = instance.name;

  return json;
}
