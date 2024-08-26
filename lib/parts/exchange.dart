part of '../models/exchange.dart';

Exchange _$ExchangeFromJson(Map<String, dynamic> json) {
  return Exchange(
    type: json['type'] != null ? json['type'] as String : null,
    fromCurrency:
        json['fromCurrency'] != null ? json['fromCurrency'] as String : null,
    fromAmount: json['fromAmount'] != null ? json['fromAmount'] as num : null,
    toCurrency:
        json['toCurrency'] != null ? json['toCurrency'] as String : null,
    toAmount: json['toAmount'] != null ? json['toAmount'] as num : null,
    toValue: json['toValue'] != null ? json['toValue'] as num : null,
    fee: json['fee'] != null ? json['fee'] as num : null,
    totalAmount:
        json['totalAmount'] != null ? json['totalAmount'] as num : null,
    sign: json['sign'] != null ? json['sign'] as String : null,
    rate: json['rate'] != null ? json['rate'] as num : null,
    bankName: json['bankName'] != null ? json['bankName'] as String : null,
    accountName:
        json['accountName'] != null ? json['accountName'] as String : null,
    accountNumber:
        json['accountNumber'] != null ? json['accountNumber'] as String : null,
    phone: json['phone'] != null ? json['phone'] as String : null,
    contract: json['contract'] != null ? json['contract'] as bool : null,
    purpose: json['purpose'] != null ? json['purpose'] as String : null,
    swiftCode: json['swiftCode'] != null ? json['swiftCode'] as String : null,
    branchName:
        json['branchName'] != null ? json['branchName'] as String : null,
    branchAddress:
        json['branchAddress'] != null ? json['branchAddress'] as String : null,
  );
}

Map<String, dynamic> _$ExchangeToJson(Exchange instance) {
  Map<String, dynamic> json = {};

  if (instance.type != null) json['type'] = instance.type;
  if (instance.fromCurrency != null)
    json['fromCurrency'] = instance.fromCurrency;
  if (instance.fromAmount != null) json['fromAmount'] = instance.fromAmount;
  if (instance.toCurrency != null) json['toCurrency'] = instance.toCurrency;
  if (instance.toAmount != null) json['toAmount'] = instance.toAmount;
  if (instance.toValue != null) json['toValue'] = instance.toValue;
  if (instance.fee != null) json['fee'] = instance.fee;
  if (instance.totalAmount != null) json['totalAmount'] = instance.totalAmount;
  if (instance.sign != null) json['sign'] = instance.sign;
  if (instance.rate != null) json['rate'] = instance.rate;

  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.accountName != null) json['accountName'] = instance.accountName;
  if (instance.accountNumber != null)
    json['accountNumber'] = instance.accountNumber;
  if (instance.phone != null) json['phone'] = instance.phone;
  if (instance.contract != null) json['contract'] = instance.contract;
  if (instance.purpose != null) json['purpose'] = instance.purpose;
  if (instance.swiftCode != null) json['swiftCode'] = instance.swiftCode;
  if (instance.branchName != null) json['branchName'] = instance.branchName;

  if (instance.branchAddress != null)
    json['branchAddress'] = instance.branchAddress;

  return json;
}
