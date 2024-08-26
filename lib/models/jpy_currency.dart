part '../parts/jpy_currency.dart';

class JpyCurrency {
  String? type;
  String? currency;
  num? get;
  num? sell;
  num? minLimit;
  num? maxLimit;

  JpyCurrency({
    this.get,
    this.sell,
    this.type,
    this.currency,
    this.minLimit,
    this.maxLimit,
  });
  static $fromJson(Map<String, dynamic> json) => _$JpyCurrencyFromJson(json);

  factory JpyCurrency.fromJson(Map<String, dynamic> json) =>
      _$JpyCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$JpyCurrencyToJson(this);
}
