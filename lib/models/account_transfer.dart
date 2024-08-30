part '../parts/account_transfer.dart';

class AccountTransfer {
  String? bankName;
  String? accountName;
  String? accountNo;
  String? description;
  num? amount;
  String? fromCurrency;
  String? toCurrency;
  String? trade;
  String? getType;

  AccountTransfer({
    this.bankName,
    this.accountName,
    this.accountNo,
    this.description,
    this.amount,
    this.fromCurrency,
    this.toCurrency,
    this.trade,
    this.getType,
  });
  static $fromJson(Map<String, dynamic> json) =>
      _$AccountTransferFromJson(json);

  factory AccountTransfer.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferFromJson(json);
  Map<String, dynamic> toJson() => _$AccountTransferToJson(this);
}
