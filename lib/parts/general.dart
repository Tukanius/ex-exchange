part of '../models/general.dart';

General _$GeneralFromJson(Map<String, dynamic> json) {
  return General(
    bankName: json['bankName'] != null
        ? (json['bankName'] as List).map((e) => BankName.fromJson(e)).toList()
        : null,
    userType: json['userType'] != null
        ? (json['userType'] as List).map((e) => UserType.fromJson(e)).toList()
        : null,
    currencyType: json['currencyType'] != null
        ? (json['currencyType'] as List)
            .map((e) => CurrencyType.fromJson(e))
            .toList()
        : null,
    objectStatus: json['objectStatus'] != null
        ? (json['objectStatus'] as List)
            .map((e) => ObjectStatus.fromJson(e))
            .toList()
        : null,
    paymentMethod: json['paymentMethod'] != null
        ? (json['paymentMethod'] as List)
            .map((e) => PaymentMethod.fromJson(e))
            .toList()
        : null,
    paymentStatus: json['paymentStatus'] != null
        ? (json['paymentStatus'] as List)
            .map((e) => PaymentStatus.fromJson(e))
            .toList()
        : null,
    purposeTypes: json['purposeTypes'] != null
        ? (json['purposeTypes'] as List)
            .map((e) => PurposeTypes.fromJson(e))
            .toList()
        : null,
    tradeTypes: json['tradeTypes'] != null
        ? (json['tradeTypes'] as List)
            .map((e) => TradeTypes.fromJson(e))
            .toList()
        : null,
    transactionStatus: json['transactionStatus'] != null
        ? (json['transactionStatus'] as List)
            .map((e) => TransactionStatus.fromJson(e))
            .toList()
        : null,
    national: json['national'] != null
        ? (json['national'] as List).map((e) => National.fromJson(e)).toList()
        : null,
  );
}

Map<String, dynamic> _$GeneralToJson(General instance) {
  Map<String, dynamic> json = {};

  if (instance.bankName != null) json['bankName'] = instance.bankName;
  if (instance.userType != null) json['userType'] = instance.userType;
  if (instance.currencyType != null)
    json['currencyType'] = instance.currencyType;
  if (instance.objectStatus != null)
    json['objectStatus'] = instance.objectStatus;
  if (instance.paymentMethod != null)
    json['paymentMethod'] = instance.paymentMethod;
  if (instance.paymentStatus != null)
    json['paymentStatus'] = instance.paymentStatus;
  if (instance.purposeTypes != null)
    json['purposeTypes'] = instance.purposeTypes;
  if (instance.tradeTypes != null) json['tradeTypes'] = instance.tradeTypes;
  if (instance.transactionStatus != null)
    json['transactionStatus'] = instance.transactionStatus;
  if (instance.national != null) json['national'] = instance.national;

  return json;
}
