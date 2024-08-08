part '../../parts/general_parts/trade_types.dart';

class TradeTypes {
  String? code;
  String? name;

  TradeTypes({
    this.code,
    this.name,
  });
  static $fromJson(Map<String, dynamic> json) => _$TradeTypesFromJson(json);

  factory TradeTypes.fromJson(Map<String, dynamic> json) =>
      _$TradeTypesFromJson(json);
  Map<String, dynamic> toJson() => _$TradeTypesToJson(this);
}
