part '../parts/history_model.dart';

class TradeHistory {
  String? id;
  String? createdby;
  String? deletedAt;
  String? user;
  String? type;
  String? fromCurrency;
  num? fromAmount;
  String? toCurrency;
  num? toAmount;
  num? rate;
  num? fee;
  num? totalAmount;
  String? sign;
  String? name;
  String? bankName;
  String? accountNumber;
  String? phone;
  String? tradeStatus;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? purpose;
  String? swiftCode;
  String? branchName;
  String? branchAddress;
  String? accountName;
  String? getType;

  TradeHistory({
    this.id,
    this.createdby,
    this.deletedAt,
    this.user,
    this.type,
    this.fromCurrency,
    this.fromAmount,
    this.toCurrency,
    this.toAmount,
    this.rate,
    this.fee,
    this.totalAmount,
    this.sign,
    this.name,
    this.bankName,
    this.accountNumber,
    this.phone,
    this.tradeStatus,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.purpose,
    this.swiftCode,
    this.branchName,
    this.branchAddress,
    this.accountName,
    this.getType,
  });
  static $fromJson(Map<String, dynamic> json) => _$TradeHistoryFromJson(json);

  factory TradeHistory.fromJson(Map<String, dynamic> json) =>
      _$TradeHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TradeHistoryToJson(this);
}
