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
  );
}

Map<String, dynamic> _$AccountTransferToJson(AccountTransfer instance) {
  Map<String, dynamic> json = {};

  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.accountName != null) json['accountName'] = instance.accountName;
  if (instance.accountNo != null) json['accountNo'] = instance.accountNo;
  if (instance.description != null) json['description'] = instance.description;
  if (instance.amount != null) json['amount'] = instance.amount;

  return json;
}
