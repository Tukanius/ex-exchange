part of '../models/account_transfer.dart';

AccountTransfer _$AccountTransferFromJson(Map<String, dynamic> json) {
  return AccountTransfer(
    bankName: json['bankName'] != null ? json['bankName'] as String : null,
    accountName:
        json['accountName'] != null ? json['accountName'] as String : null,
    accountNo: json['accountNo'] != null ? json['accountNo'] as String : null,
    description:
        json['description'] != null ? json['description'] as String : null,
    amount: json['amount'] != null ? json['amount'] as num : null,
    fromCurrency:
        json['fromCurrency'] != null ? json['fromCurrency'] as String : null,
    toCurrency:
        json['toCurrency'] != null ? json['toCurrency'] as String : null,
    trade: json['trade'] != null ? json['trade'] as String : null,
    getType: json['getType'] != null ? json['getType'] as String : null,
  );
}

Map<String, dynamic> _$AccountTransferToJson(AccountTransfer instance) {
  Map<String, dynamic> json = {};

  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.accountName != null) json['accountName'] = instance.accountName;
  if (instance.accountNo != null) json['accountNo'] = instance.accountNo;
  if (instance.description != null) json['description'] = instance.description;
  if (instance.amount != null) json['amount'] = instance.amount;
  if (instance.fromCurrency != null)
    json['fromCurrency'] = instance.fromCurrency;
  if (instance.toCurrency != null) json['toCurrency'] = instance.toCurrency;
  if (instance.trade != null) json['trade'] = instance.trade;
  if (instance.getType != null) json['getType'] = instance.getType;

  return json;
}
