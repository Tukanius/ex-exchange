part of '../models/general.dart';

General _$GeneralFromJson(Map<String, dynamic> json) {
  return General(
    bankNames: json['bankNames'] != null
        ? (json['bankNames'] as List).map((e) => BankNames.fromJson(e)).toList()
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
    amountRange: json['amountRange'] != null
        ? (json['amountRange'] as List)
            .map((e) => AmountRange.fromJson(e))
            .toList()
        : null,
    userNotfication: json['userNotfication'] != null
        ? json['userNotfication'] as bool
        : null,
    minMax: json['minMax'] != null ? new MinMax.fromJson(json['minMax']) : null,
    contract: json['contract'] != null ? json['contract'] as String : null,
  );
}

Map<String, dynamic> _$GeneralToJson(General instance) {
  Map<String, dynamic> json = {};

  if (instance.bankNames != null) json['bankNames'] = instance.bankNames;
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
  if (instance.amountRange != null) json['amountRange'] = instance.amountRange;
  if (instance.userNotfication != null)
    json['userNotfication'] = instance.userNotfication;
  if (instance.minMax != null) json['minMax'] = instance.minMax;
  if (instance.contract != null) json['contract'] = instance.contract;

  return json;
}
