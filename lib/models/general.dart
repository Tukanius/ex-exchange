import 'package:wx_exchange_flutter/models/general_%20models/amount_range.dart';
import 'package:wx_exchange_flutter/models/general_%20models/bank_name.dart';
import 'package:wx_exchange_flutter/models/general_%20models/currency_type.dart';
import 'package:wx_exchange_flutter/models/general_%20models/minMax.dart';
import 'package:wx_exchange_flutter/models/general_%20models/national.dart';
import 'package:wx_exchange_flutter/models/general_%20models/object_status.dart';
import 'package:wx_exchange_flutter/models/general_%20models/payment_method.dart';
import 'package:wx_exchange_flutter/models/general_%20models/payment_status.dart';
import 'package:wx_exchange_flutter/models/general_%20models/purpose_types.dart';
import 'package:wx_exchange_flutter/models/general_%20models/trade_types.dart';
import 'package:wx_exchange_flutter/models/general_%20models/transaction_status.dart';
import 'package:wx_exchange_flutter/models/general_%20models/user_type.dart';

part '../parts/general.dart';

class General {
  List<BankNames>? bankNames;
  List<UserType>? userType;
  List<CurrencyType>? currencyType;
  List<ObjectStatus>? objectStatus;
  List<PaymentMethod>? paymentMethod;
  List<PaymentStatus>? paymentStatus;
  List<PurposeTypes>? purposeTypes;
  List<TradeTypes>? tradeTypes;
  List<TransactionStatus>? transactionStatus;
  List<National>? national;
  List<AmountRange>? amountRange;
  bool? userNotfication;
  String? contract;
  MinMax? minMax;

  General({
    this.bankNames,
    this.userType,
    this.currencyType,
    this.objectStatus,
    this.paymentMethod,
    this.paymentStatus,
    this.purposeTypes,
    this.tradeTypes,
    this.transactionStatus,
    this.national,
    this.amountRange,
    this.userNotfication,
    this.minMax,
    this.contract,
  });
  static $fromJson(Map<String, dynamic> json) => _$GeneralFromJson(json);

  factory General.fromJson(Map<String, dynamic> json) =>
      _$GeneralFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralToJson(this);
}
