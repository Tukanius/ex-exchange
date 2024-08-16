import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/account_transfer.dart';
import 'package:wx_exchange_flutter/models/history_model.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/payment_info_page.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class OrderDetailPageArguments {
  TradeHistory data;
  OrderDetailPageArguments({
    required this.data,
  });
}

class OrderDetailPage extends StatefulWidget {
  final TradeHistory data;
  static const routeName = "OrderDetailPage";
  const OrderDetailPage({super.key, required this.data});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late String createdDate = Utils.formatUTC8(widget.data.createdAt!);
  AccountTransfer payData = AccountTransfer();

  onSubmit() async {
    try {
      payData = await ExchangeApi().getPay(widget.data.id!);
      Navigator.of(context).pushNamed(
        PaymentDetailPage.routeName,
        arguments: PaymentDetailPageArguments(
          data: payData,
        ),
      );
    } catch (e) {
      print(e.toString());
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
                    widget.data.tradeStatus == "SUCCESS"
                        ? TextSpan(
                            text: 'Амжилттай',
                            style: TextStyle(
                              color: success,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : widget.data.tradeStatus == "SUCCESS"
                            ? TextSpan(
                                text: 'Төлбөр төлөгдөөгүй',
                                style: TextStyle(
                                  color: yellow,
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
                        labelText: 'Төгрөг  / лимит: 25,000,000 /',
                        name: 'mnt',
                        focusNode: mnt,
                        borderColor: blue,
                        colortext: dark,
                        readOnly: true,
                        initialValue: '₮ ${widget.data.fromAmount}',
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
                        labelText: 'Иен  / лимит: 5,000,000 /',
                        name: 'yen',
                        focusNode: yen,
                        borderColor: blue,
                        colortext: dark,
                        initialValue: '₮ ${widget.data.toAmount}',
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
                  border: Border.all(color: borderColor),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.data.name}',
                        style: TextStyle(
                          color: dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Хүлээн авагчийн банк: ',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '${widget.data.bankName}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                              text: 'Дансны дугаар: ',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              // text: '${widget.data.bankCardNo}',
                              text: '123',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                              text: 'Утасны дугаар: ',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '${widget.data.phone}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '1 MNT = ${widget.data.rate} JPY',
                style: TextStyle(
                  color: dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Нийт төлөх дүн: ₮${widget.data.totalAmount}',
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
                'Шимтгэл: ₮${widget.data.fee}',
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
                        'Хүлээн авах дүн:',
                        style: TextStyle(
                          color: blue.withOpacity(0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '¥ ${widget.data.toAmount}',
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
                      isLoading: false,
                      labelText: 'Төлбөр төлөх',
                      textColor: white,
                    )
                  : SizedBox(),
              // widget.id == 1 || widget.id == 2
              //     ? CustomButton(
              //         onClick: () {
              //           Navigator.of(context).pop();
              //         },
              //         buttonColor: blue,
              //         isLoading: false,
              //         labelText: 'Төлбөр төлөх',
              //         textColor: white,
              //       )
              //     : SizedBox(),
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
