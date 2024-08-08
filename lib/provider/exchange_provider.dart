import 'package:flutter/material.dart';

class ExchangeProvider extends ChangeNotifier {
  String mnt = '0';
  String currency = '0';
  String receiver = '';
  String bankid = '';
  String bank = '';
  String phone = '';
  String toValue = '';
  String totalAmount = '';
  String fee = '';
  String toAmount = '';

  String purpose = '';
  String nameEng = '';
  String idCardNo = '';
  String cityName = '';
  String bankCardNo = '';

  updateAll({
    required String newmnt,
    required String newcurrency,
    required String newtoValue,
    required String newtotalAmount,
    required String newfee,
    required String newtoAmount,
  }) {
    mnt = newmnt;
    currency = newcurrency;
    toValue = newtoValue;
    totalAmount = newtotalAmount;
    fee = newfee;
    toAmount = newtoAmount;
    notifyListeners();
  }

  toUpdateUser({
    required String newreceiver,
    required String newbankid,
    required String newbank,
    required String newphone,
  }) {
    receiver = newreceiver;
    bankid = newbankid;
    bank = newbank;
    phone = newphone;
    notifyListeners();
  }

  toUpdateTransfer({
    required String newuserName,
    required String newPurpose,
    required String newnameEng,
    required String newidCardNo,
    required String newcityName,
    required String newPhone,
    required String newbankCardNo,
  }) {
    phone = newPhone;
    receiver = newuserName;
    purpose = newPurpose;
    nameEng = newnameEng;
    idCardNo = newidCardNo;
    cityName = newcityName;
    bankCardNo = newbankCardNo;

    notifyListeners();
  }
}
