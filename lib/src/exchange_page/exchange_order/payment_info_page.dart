import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/account_transfer.dart';
import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/src/main_page.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class PaymentDetailPageArguments {
  AccountTransfer data;
  String type;
  PaymentDetailPageArguments({
    required this.data,
    required this.type,
  });
}

class PaymentDetailPage extends StatefulWidget {
  final AccountTransfer data;
  final String type;
  static const routeName = "PaymentDetailPage";
  const PaymentDetailPage({
    super.key,
    required this.data,
    required this.type,
  });

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage>
    with AfterLayoutMixin {
  String? matchedPurpose;
  General general = General();
  bool isLoading = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    general = Provider.of<GeneralProvider>(context, listen: false).general;
    try {
      setState(() {
        isLoading = true;
      });
      for (var bankNames in general.bankNames!) {
        if (bankNames.code == widget.data.bankName) {
          matchedPurpose = bankNames.name;
          break;
        }
      }
      setState(() {
        isLoading = false;
      });
      print(matchedPurpose);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  bool dans = false;
  bool utga = false;
  bool dun = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: white,
            elevation: 0,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                widget.data.trade == "EXCHANGE"
                    ? Navigator.of(context).pushNamed(
                        MainPage.routeName,
                        arguments: MainPageArguments(initialIndex: 0),
                      )
                    : Navigator.of(context).pushNamed(
                        MainPage.routeName,
                        arguments: MainPageArguments(initialIndex: 1),
                      );
              },
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Center(
                  child: SvgPicture.asset('assets/svg/back_arrow.svg'),
                ),
              ),
            ),
            title: Text(
              'Төлбөр төлөх',
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Шилжүүлэг хийх банк',
                                  style: TextStyle(
                                    color: hintText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${matchedPurpose ?? widget.data.bankName}',
                                  style: TextStyle(
                                    color: hintText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Шилжүүлэг хийх данс',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${widget.data.accountNo}',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dans = true;
                                      utga = false;
                                      dun = false;
                                    });
                                    Clipboard.setData(ClipboardData(
                                            text: '${widget.data.accountNo}'))
                                        .then(
                                      (value) {
                                        return ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: blue,
                                            content: Text(
                                              'Амжилттай хуулсан',
                                              style: TextStyle(
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: dans == false
                                      ? SvgPicture.asset('assets/svg/copy.svg')
                                      : Icon(Icons.check),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Шилжүүлэг хийх дансны нэр',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${widget.data.accountName}',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Гүйлгээний утга',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${widget.data.description}',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dans = false;
                                      utga = true;
                                      dun = false;
                                    });
                                    Clipboard.setData(ClipboardData(
                                            text: '${widget.data.description}'))
                                        .then(
                                      (value) {
                                        return ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: blue,
                                            content: Text(
                                              'Амжилттай хуулсан',
                                              style: TextStyle(
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: utga == false
                                      ? SvgPicture.asset('assets/svg/copy.svg')
                                      : Icon(Icons.check),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Шилжүүлэг хийх дүн',
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    widget.type == "TRANSFER"
                                        ? Text(
                                            '₮ ${Utils().formatCurrencyCustom(widget.data.amount)}',
                                            style: TextStyle(
                                              color: hintText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : widget.type == "EXCHANGE"
                                            ? Text(
                                                '${widget.data.getType == "BUY" ? "₮" : "¥"}  ${Utils().formatCurrencyCustom(widget.data.amount)}',
                                                style: TextStyle(
                                                  color: hintText,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : SizedBox()
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dans = false;
                                      utga = false;
                                      dun = true;
                                    });
                                    Clipboard.setData(ClipboardData(
                                            text: '${widget.data.amount}'))
                                        .then(
                                      (value) {
                                        return ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: blue,
                                            content: Text(
                                              'Амжилттай хуулсан',
                                              style: TextStyle(
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: dun == false
                                      ? SvgPicture.asset('assets/svg/copy.svg')
                                      : Icon(Icons.check),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: grayAccent,
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: borderColor,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(text: 'Үйлчлүүлэгч та гуйвуулах '),
                                TextSpan(
                                  text: 'мөнгөн дүн',
                                  style: TextStyle(
                                    color: dark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: ' болон '),
                                TextSpan(
                                  text: 'гүйлгээний утгаа',
                                  style: TextStyle(
                                    color: dark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' сайтар шалган илгээнэ үү. Буруу илгээсэн тохиолдолд гуйвуулга буруу хийгдэхийг анхаарна уу!',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        CustomButton(
                          onClick: () {
                            widget.data.trade == "EXCHANGE"
                                ? Navigator.of(context).pushNamed(
                                    MainPage.routeName,
                                    arguments:
                                        MainPageArguments(initialIndex: 0),
                                  )
                                : Navigator.of(context).pushNamed(
                                    MainPage.routeName,
                                    arguments:
                                        MainPageArguments(initialIndex: 1),
                                  );
                          },
                          buttonColor: blue.withOpacity(0.1),
                          isLoading: false,
                          labelText: 'Нүүр хуудас руу буцах',
                          textColor: blue,
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                )),
    );
  }
}
