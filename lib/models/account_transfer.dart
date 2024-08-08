part '../parts/account_transfer.dart';

class AccountTransfer {
  String? bankName;
  String? accountName;
  String? accountNo;
  String? description;
  num? amount;

  AccountTransfer({
    this.bankName,
    this.accountName,
    this.accountNo,
    this.description,
    this.amount,
  });
  static $fromJson(Map<String, dynamic> json) =>
      _$AccountTransferFromJson(json);

  factory AccountTransfer.fromJson(Map<String, dynamic> json) =>
      _$AccountTransferFromJson(json);
  Map<String, dynamic> toJson() => _$AccountTransferToJson(this);
}
