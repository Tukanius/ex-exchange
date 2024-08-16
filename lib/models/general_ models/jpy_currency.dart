part '../../parts/general_parts/jpy_currency.dart';

class JpyCurrency {
  num? get;
  num? sell;

  JpyCurrency({
    this.get,
    this.sell,
  });
  static $fromJson(Map<String, dynamic> json) => _$JpyCurrencyFromJson(json);

  factory JpyCurrency.fromJson(Map<String, dynamic> json) =>
      _$JpyCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$JpyCurrencyToJson(this);
}
