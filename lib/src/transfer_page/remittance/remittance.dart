import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class RemittancePageArguments {
  Uint8List signature;
  RemittancePageArguments({
    required this.signature,
  });
}

class RemittancePage extends StatefulWidget {
  final Uint8List signature;
  static const routeName = "RemittancePage";
  const RemittancePage({super.key, required this.signature});

  @override
  State<RemittancePage> createState() => _RemittancePageState();
}

class _RemittancePageState extends State<RemittancePage> {
  FocusNode mnt = FocusNode();
  FocusNode yen = FocusNode();
  Exchange data = Exchange();
  AccountTransfer payData = AccountTransfer();
  bool isLoading = false;
  onSubmit(ExchangeProvider tools, General general) async {
    print('=========general=========');
    print(general.purposeTypes!.first.name);
    print('=========general=========');

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
      data.purpose = matchedPurpose ?? 'VEHICLE';
      data.type = "TRANSFER";
      data.fromCurrency = "JPY";
      data.fromAmount = tools.mnt;
      data.toCurrency = "MNT";
      data.toAmount = num.parse(tools.toAmount);
      data.rate = num.parse(tools.toValue);
      data.fee = tools.fee;
      data.sign = base64Encode(widget.signature);
      data.contract = true;
      data.bankName = tools.BankName;
      data.accountNumber = tools.AccountNumber;
      data.swiftCode = tools.SwiftCode;
      data.branchName = tools.BranchName;
      data.branchAddress = tools.BranchAddress;
      data.accountName = tools.AccountName;

      payData = await ExchangeApi().onTrade(data);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushNamed(
        PaymentDetailPage.routeName,
        arguments: PaymentDetailPageArguments(
          data: payData,
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
          'Төлбөр баталгаажуулах',
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
                        readOnly: true,
                        labelText: 'Илгээх дүн',
                        name: 'mnt',
                        focusNode: mnt,
                        borderColor: blue,
                        colortext: dark,
                        initialValue:
                            '¥ ${Utils().formatTextCustom(tools.mnt)}',
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
                        labelText: 'Дүн',
                        name: 'yen',
                        focusNode: yen,
                        borderColor: blue,
                        colortext: dark,
                        initialValue: '₮ ${tools.currency}',
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
                              'Bank name:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.BankName}',
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
                              'Account number:',
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
                              'Swift code:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.SwiftCode}',
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
                              'Branch name:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.BranchName}',
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
                              'Branch address:',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${tools.BranchAddress}',
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
                              'Account name:',
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
                'Шимтгэл: ₮ ${Utils().formatTextCustom(tools.fee)}',
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
                'Гуйвуулах дүн: ¥ ${Utils().formatTextCustom(tools.mnt)}',
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
                  padding: EdgeInsets.all(16),
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
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '₮ ${Utils().formatCurrencyCustom(tools.totalAmount)}',
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
                isLoading: isLoading,
                labelText: 'Гуйвуулга хийх',
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
