part '../parts/exchange.dart';

class Exchange {
  String? type;
  String? fromCurrency;
  num? fromAmount;
  String? toCurrency;
  num? toAmount;
  num? toValue;
  num? fee;
  num? totalAmount;
  num? rate;
  String? sign;
  String? bankName;
  String? name;
  String? bankCardNo;
  String? phone;
  bool? contract;
  String? purpose;
  String? nameEng;
  String? idCardNo;
  String? cityName;

  Exchange({
    this.type,
    this.fromCurrency,
    this.fromAmount,
    this.toCurrency,
    this.toAmount,
    this.toValue,
    this.fee,
    this.totalAmount,
    this.sign,
    this.rate,
    this.bankName,
    this.name,
    this.bankCardNo,
    this.phone,
    this.contract,
    this.purpose,
    this.nameEng,
    this.idCardNo,
    this.cityName,
  });
  static $fromJson(Map<String, dynamic> json) => _$ExchangeFromJson(json);

  factory Exchange.fromJson(Map<String, dynamic> json) =>
      _$ExchangeFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeToJson(this);
}
