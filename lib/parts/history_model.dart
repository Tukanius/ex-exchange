part of '../models/history_model.dart';

TradeHistory _$TradeHistoryFromJson(Map<String, dynamic> json) {
  return TradeHistory(
    id: json['_id'] != null ? json['_id'] as String : null,
    createdby: json['createdby'] != null ? json['createdby'] as String : null,
    deletedAt: json['deletedAt'] != null ? json['deletedAt'] as String : null,
    user: json['user'] != null ? json['user'] as String : null,
    type: json['type'] != null ? json['type'] as String : null,
    fromCurrency:
        json['fromCurrency'] != null ? json['fromCurrency'] as String : null,
    fromAmount: json['fromAmount'] != null ? json['fromAmount'] as num : null,
    toCurrency:
        json['toCurrency'] != null ? json['toCurrency'] as String : null,
    toAmount: json['toAmount'] != null ? json['toAmount'] as num : null,
    rate: json['rate'] != null ? json['rate'] as num : null,
    fee: json['fee'] != null ? json['fee'] as num : null,
    totalAmount:
        json['totalAmount'] != null ? json['totalAmount'] as num : null,
    sign: json['sign'] != null ? json['sign'] as String : null,
    name: json['name'] != null ? json['name'] as String : null,
    bankName: json['bankName'] != null ? json['bankName'] as String : null,
    accountNumber:
        json['accountNumber'] != null ? json['accountNumber'] as String : null,
    phone: json['phone'] != null ? json['phone'] as String : null,
    tradeStatus:
        json['tradeStatus'] != null ? json['tradeStatus'] as String : null,
    createdAt: json['createdAt'] != null ? json['createdAt'] as String : null,
    updatedAt: json['updatedAt'] != null ? json['updatedAt'] as String : null,
    description:
        json['description'] != null ? json['description'] as String : null,
    purpose: json['purpose'] != null ? json['purpose'] as String : null,
    swiftCode: json['swiftCode'] != null ? json['swiftCode'] as String : null,
    branchName:
        json['branchName'] != null ? json['branchName'] as String : null,
    branchAddress:
        json['branchAddress'] != null ? json['branchAddress'] as String : null,
    accountName:
        json['accountName'] != null ? json['accountName'] as String : null,
    getType: json['getType'] != null ? json['getType'] as String : null,
  );
}

Map<String, dynamic> _$TradeHistoryToJson(TradeHistory instance) {
  Map<String, dynamic> json = {};

  if (instance.id != null) json['_id'] = instance.id;
  if (instance.createdby != null) json['createdby'] = instance.createdby;
  if (instance.deletedAt != null) json['deletedAt'] = instance.deletedAt;
  if (instance.user != null) json['user'] = instance.user;
  if (instance.type != null) json['type'] = instance.type;
  if (instance.fromCurrency != null)
    json['fromCurrency'] = instance.fromCurrency;
  if (instance.fromAmount != null) json['fromAmount'] = instance.fromAmount;
  if (instance.toCurrency != null) json['toCurrency'] = instance.toCurrency;
  if (instance.toAmount != null) json['toAmount'] = instance.toAmount;
  if (instance.rate != null) json['rate'] = instance.rate;
  if (instance.fee != null) json['fee'] = instance.fee;
  if (instance.totalAmount != null) json['totalAmount'] = instance.totalAmount;
  if (instance.sign != null) json['sign'] = instance.sign;
  if (instance.name != null) json['name'] = instance.name;
  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.accountNumber != null)
    json['accountNumber'] = instance.accountNumber;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.tradeStatus != null) json['tradeStatus'] = instance.tradeStatus;
  if (instance.createdAt != null) json['createdAt'] = instance.createdAt;
  if (instance.updatedAt != null) json['updatedAt'] = instance.updatedAt;
  if (instance.description != null) json['description'] = instance.description;
  if (instance.purpose != null) json['purpose'] = instance.purpose;
  if (instance.swiftCode != null) json['swiftCode'] = instance.swiftCode;
  if (instance.branchName != null) json['branchName'] = instance.branchName;
  if (instance.branchAddress != null)
    json['branchAddress'] = instance.branchAddress;
  if (instance.accountName != null) json['accountName'] = instance.accountName;
  if (instance.getType != null) json['getType'] = instance.getType;

  return json;
}
