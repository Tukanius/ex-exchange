import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/account_transfer.dart';
import 'package:wx_exchange_flutter/models/exchange.dart';
import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/provider/exchange_provider.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/payment_info_page.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class OrderInfoPageArguments {
  Uint8List signature;
  OrderInfoPageArguments({
    required this.signature,
  });
}

class OrderInfoPage extends StatefulWidget {
  final Uint8List signature;

  static const routeName = "OrderInfoPage";
  const OrderInfoPage({super.key, required this.signature});

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  FocusNode mnt = FocusNode();
  FocusNode yen = FocusNode();
  Exchange data = Exchange();
  AccountTransfer payData = AccountTransfer();
  bool isLoading = false;

  String getBankName(String code) {
    switch (code) {
      case 'KHANBANK':
        return 'Хаан банк';
      case 'GOLOMTBANK':
        return 'Голомт банк';
      case 'TDBANK':
        return 'Худалдаа хөгжлийн банк';
      case 'KHASBANK':
        return 'Хас банк';
      case 'CREDITBANK':
        return 'Кредит банк';
      case 'STATEBANK':
        return 'Төрийн банк';
      case 'ARIGBANK':
        return 'Ариг банк';
      case 'CAPITRONBANK':
        return 'Капитрон банк';
      case 'MBANK':
        return 'М банк';
      case 'BOGDBANK':
        return 'Богд банк';
      case 'TRANSDEVBANK':
        return 'Тээвэр хөгжлийн банк';
      case 'NIBANK':
        return 'Үндэсний хөрөнгө оруулалтын банк';
      case 'CHINGISKHANBANK':
        return 'Чингис хаан банк';
      default:
        return 'Хаан банк';
    }
  }

  onSubmit(ExchangeProvider tools, General general) async {
    print('HELOOO');
    print(tools.toString());
    print('HELOOO');

    try {
      setState(() {
        isLoading = true;
      });
      String? matchedPurpose;
      for (var purposeType in general.purposeTypes!) {
        if (purposeType.name == tools.tradePurpose) {
          matchedPurpose = purposeType.code;
          break;
        }
      }
      data.type = "EXCHANGE";
      data.fromCurrency = "MNT";
      data.fromAmount = tools.mnt;
      data.toCurrency = "JPY";
      data.toAmount = num.parse(tools.toAmount);
      data.rate = num.parse(tools.toValue);
      data.fee = tools.fee;
      data.bankName = tools.BankName;
      data.purpose = matchedPurpose;
      data.accountNumber = tools.AccountNumber;
      data.accountName = tools.AccountName;
      data.phone = tools.phone;
      // data.name = tools.receiver;
      // data.bankCardNo = tools.bankid;
      data.sign = base64Encode(widget.signature);
      // data.phone = tools.phone;
      data.contract = true;

      // data.purpose = 'FOOD';
      // data.nameEng = "TUKANIUS";
      // data.idCardNo = "12341234";
      // data.cityName = "TOKYO";

      payData = await ExchangeApi().onTrade(data);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushNamed(
        PaymentDetailPage.routeName,
        arguments: PaymentDetailPageArguments(
          data: payData,
          type: "EXCHANGE",
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var tools = Provider.of<ExchangeProvider>(context, listen: true);
    var general = Provider.of<GeneralProvider>(context, listen: true).general;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Center(
              child: SvgPicture.asset('assets/svg/back_arrow.svg'),
            ),
          ),
        ),
        title: Text(
          'Захиалгын дэлгэрэнгүй',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: AnimatedTextField(
                        labelText: 'Төгрөг',
                        name: 'mnt',
                        focusNode: mnt,
                        borderColor: blue,
                        colortext: dark,
                        initialValue:
                            '₮ ${Utils().formatTextCustom(tools.mnt)}',
                        readOnly: true,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            SvgPicture.asset('assets/svg/mn.svg'),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Divider(
                            color: borderColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 42),
                          child: SvgPicture.asset(
                            'assets/svg/trade_divider.svg',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: AnimatedTextField(
                        labelText: 'Иен',
                        readOnly: true,
                        name: 'yen',
                        focusNode: yen,
                        borderColor: blue,
                        colortext: dark,
                        initialValue: '¥ ${tools.currency}',
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            SvgPicture.asset('assets/svg/jp.svg'),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Хүлээн авагч',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: borderColor),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Хүлээн авагчийн нэр:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.AccountName}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Хүлээн авагчийн банк:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${getBankName(tools.BankName)}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Дансны дугаар:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.AccountNumber}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Харилцах утас:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.phone}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Төлбөрийн зориулалт:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.tradePurpose}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '1 JPY = ${tools.toValue} MNT',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Шимтгэл: ¥ ${Utils().formatTextCustom(tools.fee)}',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Хүлээн авах дүн: ₮ ${Utils().formatTextCustom(tools.mnt)}',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: blue, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Нийт төлөх дүн:',
                        style: TextStyle(
                          color: blue.withOpacity(0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '¥ ${Utils().formatCurrencyCustom(tools.totalAmount)}',
                        style: TextStyle(
                          color: blue,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Гарын үсэг',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: dark.withOpacity(0.75),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: SvgPicture.asset('assets/svg/edit.svg'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Засах',
                                style: TextStyle(
                                  color: dark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Image.memory(widget.signature),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                onClick: () {
                  onSubmit(tools, general);
                },
                buttonColor: blue,
                isLoading: false,
                labelText: 'Төлбөр төлөх',
                textColor: white,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
