import 'package:flutter/material.dart';

class ExchangeProvider extends ChangeNotifier {
  num mnt = 0;
  num currency = 0;
  String receiver = '';
  String bankid = '';
  String bank = '';
  String phone = '';
  String toValue = '';
  num totalAmount = 0;
  num fee = 0;
  String toAmount = '';
  String purpose = '';
  String nameEng = '';
  String idCardNo = '';
  String cityName = '';
  String bankCardNo = '';
  bool sell = false;

  updateAll({
    required num newmnt,
    required num newcurrency,
    required String newtoValue,
    required num newtotalAmount,
    required num newfee,
    required String newtoAmount,
    required bool isSell,
  }) {
    mnt = newmnt;
    currency = newcurrency;
    toValue = newtoValue;
    totalAmount = newtotalAmount;
    fee = newfee;
    toAmount = newtoAmount;
    sell = isSell;
    notifyListeners();
  }

  toUpdateUser({
    required String newreceiver,
    required String newbankid,
    required String newbank,
    required String newphone,
    required String newexchangePurpose,
  }) {
    AccountName = newreceiver;
    AccountNumber = newbankid;
    BankName = newbank;
    phone = newphone;
    tradePurpose = newexchangePurpose;
    notifyListeners();
  }

  String BankName = '';
  String AccountNumber = '';
  String SwiftCode = '';
  String BranchName = '';
  String BranchAddress = '';
  String AccountName = '';
  String tradePurpose = '';

  toUpdateTransfer({
    required String newBankName,
    required String newAccountNumber,
    required String newSwiftCode,
    required String newBranchName,
    required String newBranchAddress,
    required String newAccountName,
    required String newPurpose,
  }) {
    BankName = newBankName;
    AccountNumber = newAccountNumber;
    SwiftCode = newSwiftCode;
    BranchName = newBranchName;
    BranchAddress = newBranchAddress;
    AccountName = newAccountName;
    tradePurpose = newPurpose;
    notifyListeners();
  }
}
