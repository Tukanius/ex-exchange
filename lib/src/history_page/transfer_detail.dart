import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/controller/listen.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/account_transfer.dart';
import 'package:wx_exchange_flutter/models/history_model.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/payment_info_page.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class TransferDetailPageArguments {
  ListenController listenController;
  TradeHistory data;
  String notifyData;
  TransferDetailPageArguments({
    required this.data,
    required this.listenController,
    required this.notifyData,
  });
}

class TransferDetailPage extends StatefulWidget {
  final TradeHistory data;
  final ListenController listenController;
  final String notifyData;
  static const routeName = "TransferDetailPage";
  const TransferDetailPage({
    super.key,
    required this.data,
    required this.listenController,
    required this.notifyData,
  });

  @override
  State<TransferDetailPage> createState() => _TransferDetailPageState();
}

class _TransferDetailPageState extends State<TransferDetailPage>
    with AfterLayoutMixin {
  String? matchedPurpose;
  bool isLoading = true;
  bool isLoadingButton = false;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var general = Provider.of<GeneralProvider>(context, listen: false).general;

    for (var purposeType in general.purposeTypes!) {
      if (purposeType.code == widget.data.purpose) {
        matchedPurpose = purposeType.name;
        break;
      }
    }
    if (widget.notifyData != '') {
      var res = await UserApi().seenNot(widget.notifyData);
      print(res);
      widget.listenController.refreshList("refresh");
    }
    setState(() {
      isLoading = false;
    });
  }

  late String createdDate = Utils.formatUTC8(widget.data.createdAt!);
  AccountTransfer payData = AccountTransfer();

  onSubmit() async {
    try {
      setState(() {
        isLoadingButton = true;
      });
      payData = await ExchangeApi().getPay(widget.data.id!);
      Navigator.of(context).pushNamed(
        PaymentDetailPage.routeName,
        arguments: PaymentDetailPageArguments(data: payData, type: "TRANSFER"),
      );
      setState(() {
        isLoadingButton = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoadingButton = false;
      });
    }
  }

  FocusNode mnt = FocusNode();
  FocusNode yen = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            FocusScope.of(context).unfocus();
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Center(
              child: SvgPicture.asset('assets/svg/back_arrow.svg'),
            ),
          ),
        ),
        title: Text(
          'Гуйвуулгын дэлгэрэнгүй',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: blue,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Огноо: ${createdDate}',
                      style: TextStyle(
                        color: dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Төлөв: ',
                            style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          widget.data.tradeStatus == "PENDING"
                              ? TextSpan(
                                  text: 'Хүлээгдэж байгаа',
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : widget.data.tradeStatus == "PAID"
                                  ? TextSpan(
                                      text: 'Төлбөр төлөгдсөн',
                                      style: TextStyle(
                                        color: success,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : TextSpan(
                                      text: 'Цуцалсан',
                                      style: TextStyle(
                                        color: cancel,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Гүйлгээний утга: ',
                            style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.data.description}',
                            style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                              labelText: 'Илгээх дүн',
                              name: 'mnt',
                              focusNode: mnt,
                              borderColor: blue,
                              colortext: dark,
                              readOnly: true,
                              initialValue:
                                  '¥ ${Utils().formatTextCustom(widget.data.fromAmount)}',
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
                              initialValue:
                                  '₮ ${Utils().formatTextCustom(widget.data.toAmount)}',
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
                                    '${widget.data.bankName}',
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
                                    '${widget.data.accountNumber}',
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
                                    '${widget.data.swiftCode}',
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
                                    '${widget.data.branchName}',
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
                                    '${widget.data.branchAddress}',
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
                                    '${widget.data.accountName}',
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
                                    '${matchedPurpose ?? widget.data.purpose}',
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
                      '1 JPY = ${widget.data.rate} MNT',
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
                      'Шимтгэл: ₮ ${Utils().formatTextCustom(widget.data.fee)}',
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
                      'Гуйвуулах дүн: ¥ ${Utils().formatTextCustom(widget.data.fromAmount)}',
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
                              '₮ ${Utils().formatCurrencyCustom(widget.data.totalAmount)}',
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
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
                                // Row(
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         Navigator.of(context).pop();
                                //       },
                                //       child: SvgPicture.asset('assets/svg/edit.svg'),
                                //     ),
                                //     SizedBox(
                                //       width: 10,
                                //     ),
                                //     Text(
                                //       'Засах',
                                //       style: TextStyle(
                                //         color: dark,
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.w400,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Image.memory(base64Decode(widget.data.sign!)),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    widget.data.tradeStatus == "PENDING"
                        ? CustomButton(
                            onClick: () {
                              onSubmit();
                            },
                            buttonColor: blue,
                            isLoading: isLoadingButton,
                            labelText: 'Төлбөр төлөх',
                            textColor: white,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
