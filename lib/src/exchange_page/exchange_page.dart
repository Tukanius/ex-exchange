// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wx_exchange_flutter/api/auth_api.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/components/history_button/history_button.dart';
import 'package:wx_exchange_flutter/components/loader/loader.dart';
import 'package:wx_exchange_flutter/models/exchange.dart';
import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/models/receiver.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/exchange_provider.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/src/exchange_page/signature/signature_check_page.dart';
import 'package:wx_exchange_flutter/src/history_page/exchange.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> with AfterLayoutMixin {
  FocusNode mnt = FocusNode();
  FocusNode yen = FocusNode();
  bool confirmterm = false;
  Receiver info = Receiver();
  bool confirmAll = false;
  String? dropBankName;
  bool isLoading = true;
  bool isLoadingHistory = true;
  Timer? timer;
  String convertedValue = '0';
  Exchange dataReceive = Exchange();
  int page = 1;
  int limit = 10;
  int pageHistory = 1;
  int limitHistory = 10;
  Result result = Result();
  Result resultHistory = Result();

  TextEditingController mntController = TextEditingController();
  TextEditingController jpnController = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  String receiverBox = '';
  String purpose = '';
  User user = User();
  General general = General();
  bool tradeSubmit = false;

  @override
  afterFirstLayout(BuildContext context) async {
    user = await AuthApi().me(false);

    try {
      await list(page, limit);
      await listHistory(page, limit);
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadingHistory = false;
        });
      }
    }
  }

  listHistory(pageHistory, limitHistory) async {
    Offset offset = Offset(page: pageHistory, limit: limitHistory);
    Filter filter = Filter(type: 'EXCHANGE');
    resultHistory = await ExchangeApi().getHistory(
      ResultArguments(filter: filter, offset: offset),
    );
    setState(() {
      isLoadingHistory = false;
    });
  }

  onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoadingHistory = true;
      limitHistory = 10;
    });
    await listHistory(pageHistory, limitHistory);
    refreshController.refreshCompleted();
  }

  onLoading() async {
    setState(() {
      limitHistory += 10;
    });
    await listHistory(pageHistory, limitHistory);
    refreshController.loadComplete();
  }

  list(page, limit) async {
    Offset offset = Offset(page: page, limit: limit);
    Filter filter = Filter(type: 'EXCHANGE');
    result = await UserApi().getReceiver(
      ResultArguments(filter: filter, offset: offset),
    );
    setState(() {
      isLoading = false;
    });
  }

  onChange(String query) async {
    setState(() {
      isValueError = query.length < 3;
      print(isValueError);
    });
    Exchange data = Exchange();
    if (timer != null) timer!.cancel();
    setState(() {
      tradeSubmit = true;
    });
    timer = Timer(const Duration(milliseconds: 1000), () async {
      if (!mounted) return;
      try {
        data.type = "EXCHANGE";
        data.fromCurrency = "MNT";
        data.toCurrency = "JPY";
        data.fromAmount = num.parse(query);
        num.parse(query) >= 100
            ? dataReceive = await ExchangeApi().tradeConvertor(data)
            : SizedBox();
        if (!mounted) return;
        setState(() {
          jpnController.text = dataReceive.toAmount?.toString() ?? '0';
        });
        setState(() {
          tradeSubmit = false;
        });
      } catch (e) {
        // end bur yg utga ni solih bolomjgui bol ym gargaj irh ystoi bha ahhah
        print(e.toString());
        if (mounted) {
          setState(() {
            jpnController.text = '0';
          });
          setState(() {
            tradeSubmit = false;
          });
        }
      }
    });
  }

// on FormatException {
//         print('Error: Invalid format for number parsing');
//         if (mounted) {
//           setState(() {
//             jpnController.text = '0';
//           });
//           setState(() {
//             tradeSubmit = false;
//           });
//         }
//       }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool isValueError = false;
  bool isSetUser = true;
  bool purposeTrade = true;

  verify() async {
    if (user.userStatus == "NEW") {
      danVerify(context);
    } else {
      if (isValueError == false) {
        setState(() {
          mntController.text.length >= 3
              ? isValueError = false
              : isValueError = true;
          print(isValueError);
        });
      }

      if (isSetUser == true) {
        if (receiverBox == '') {
          setState(() {
            isSetUser = false;
          });
        } else {
          setState(() {
            isSetUser = true;
          });
        }
      }

      if (purposeTrade == true) {
        if (purpose == '') {
          setState(() {
            purposeTrade = false;
          });
        } else {
          setState(() {
            purposeTrade = true;
          });
        }
      }
      print(isValueError);
      print(isSetUser);
      print(purposeTrade);

      if (isValueError == false && isSetUser == true && purposeTrade == true) {
        confirm(context, info);
      } else {
        print("error");
      }
    }
  }

  void updateReceiverBox(String name) {
    setState(() {
      receiverBox = name;
    });
  }

  void updatePurposePayment(String name) {
    setState(() {
      purpose = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    general = Provider.of<GeneralProvider>(context, listen: false).general;
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: isLoading == true
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/svg/trade.svg'),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Валют арилжаа',
                              style: TextStyle(
                                color: dark,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                ),
                                child: AnimatedTextField(
                                  onChanged: (query) {
                                    onChange(query);
                                  },
                                  floatLabel: FloatingLabelBehavior.always,
                                  labelText: 'Төгрөг  / лимит: 25,000,000 /',
                                  name: 'mnt',
                                  focusNode: mnt,
                                  borderColor: isValueError ? redError : blue,
                                  colortext: dark,
                                  hintText: '₮0',
                                  hintTextColor: hintColor,
                                  inputType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  controller: mntController,
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
                              isValueError == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 32,
                                        right: 16,
                                        top: 4,
                                      ),
                                      child: Text(
                                        'Арилжих хамгийн бага утга 100.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: redError,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     left: 16,
                              //     right: 16,
                              //     top: 16,
                              //   ),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12),
                              //       border:
                              //           Border.all(color: borderColor, width: 1),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //         horizontal: 16,
                              //         vertical: 13,
                              //       ),
                              //       child: Row(
                              //         children: [
                              //           Image.asset('assets/images/mn.png'),
                              //           SizedBox(
                              //             width: 12,
                              //           ),
                              //           Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text('Төгрөг  / лимит: 25,000,000 /'),
                              //               Text('₮ 1,000,000'),
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                                  floatLabel: FloatingLabelBehavior.always,
                                  readOnly: true,
                                  labelText: 'Иен  / лимит: 5,000,000 /',
                                  name: 'yen',
                                  focusNode: yen,
                                  borderColor: blue,
                                  colortext: dark,
                                  controller: jpnController,
                                  hintText: '¥0',
                                  hintTextColor: hintColor,
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
                              SizedBox(height: 5),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     left: 16,
                              //     right: 16,
                              //     bottom: 16,
                              //   ),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12),
                              //       border: Border.all(color: borderColor),
                              //     ),
                              //     child: NotAnimatedFormField(
                              //       labelText: 'Иен  / лимит: 5,000,000 /',
                              //       name: 'yen',
                              //       colortext: dark,
                              //       hintText: '¥0',
                              //       hintTextColor: hintColor,
                              //       prefixIcon: Row(
                              //         mainAxisSize: MainAxisSize.min,
                              //         children: [
                              //           SizedBox(
                              //             width: 16,
                              //           ),
                              //           SvgPicture.asset('assets/svg/jp.svg'),
                              //           SizedBox(
                              //             width: 12,
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     left: 16,
                              //     right: 16,
                              //     bottom: 16,
                              //   ),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12),
                              //       border:
                              //           Border.all(color: borderColor, width: 1),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //         horizontal: 16,
                              //         vertical: 13,
                              //       ),
                              //       child: Row(
                              //         children: [
                              //           Image.asset('assets/images/mn.png'),
                              //           SizedBox(
                              //             width: 12,
                              //           ),
                              //           Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text('Иен  / лимит: 5,000,000 /'),
                              //               Text('¥ 46,324'),
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          '1 JPY = ${dataReceive.toValue ?? 0} MNT',
                          style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Шимтгэл: ₮ ${dataReceive.fee ?? 0}',
                          style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            addReceiver(context, general);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSetUser == true ? borderColor : red,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/svg/user.svg'),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      receiverBox == ''
                                          ? Text(
                                              'Хүлээн авагч',
                                              style: TextStyle(
                                                color: hintColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Хүлээн авагч',
                                                  style: TextStyle(
                                                    color: hintColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  '${receiverBox}',
                                                  style: TextStyle(
                                                    color: black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded)
                                ],
                              ),
                            ),
                          ),
                        ),
                        isSetUser == false
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 4,
                                ),
                                child: Text(
                                  'Хүлээн авагч олдсонгүй.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: redError,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            puposePayment(context, general);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      purposeTrade == true ? borderColor : red,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    purpose == ""
                                        ? Text(
                                            'Төлбөрийн зориулалт',
                                            style: TextStyle(
                                              color: hintColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Төлбөрийн зориулалт',
                                                style: TextStyle(
                                                  color: hintColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                '${purpose}',
                                                style: TextStyle(
                                                  color: black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                    Icon(Icons.keyboard_arrow_down_rounded)
                                  ],
                                ),
                              )),
                        ),
                        purposeTrade == false
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 4,
                                ),
                                child: Text(
                                  'Төлбөрийн зориулалт олдсонгүй.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: redError,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          onClick: () async {
                            await verify();
                          },
                          buttonColor: blue,
                          textColor: white,
                          isLoading: tradeSubmit,
                          labelText: 'Арилжаа хийх',
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/history.svg',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Гүйлгээний түүх',
                              style: TextStyle(
                                color: dark,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        isLoadingHistory == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: blue,
                                ),
                              )
                            : resultHistory.rows!.isNotEmpty
                                ? Column(
                                    children: resultHistory.rows!
                                        .map(
                                          (data) => GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                OrderDetailPage.routeName,
                                                arguments:
                                                    OrderDetailPageArguments(
                                                  data: data,
                                                ),
                                              );
                                            },
                                            child: TradeHistoryButton(
                                              data: data,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 80,
                                        ),
                                        SvgPicture.asset(
                                          'assets/svg/notfound.svg',
                                          color: dark,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Түүх олдсонгүй.',
                                          style: TextStyle(
                                            color: dark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                  ),
                        // Expanded(
                        //   child: Refresher(
                        //     refreshController: refreshController,
                        //     color: blue,
                        //     onLoading: onLoading,
                        //     onRefresh: onRefresh,
                        //     child:
                        //   ),
                        // ),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading == true) CustomLoader()
              ],
            ),
          ),
        ),
      ],
    );
  }

  addReceiver(BuildContext context, General general) {
    FocusNode receiverNameFocusNode = FocusNode();
    FocusNode receiverBank = FocusNode();
    FocusNode bankId = FocusNode();
    FocusNode receiverPhone = FocusNode();
    TextEditingController receiverNameController = TextEditingController();
    TextEditingController receiverBankController = TextEditingController();
    TextEditingController bankIdController = TextEditingController();
    TextEditingController receiverPhoneController = TextEditingController();
    int selectedContainerIndex = -1;

    Widget buildContainer(data, int index) {
      return Container(
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedContainerIndex == index ? blue : borderColor,
            width: 1,
          ),
          color:
              selectedContainerIndex == index ? blue.withOpacity(0.1) : white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          child: Container(
            width: 120,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/check.svg',
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Хүлээн авагч',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: hintText,
                        ),
                      ),
                      Text(
                        '${data.name}',
                        style: TextStyle(
                          color: dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            receiverBank.addListener(() {
              if (receiverBank.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            receiverNameFocusNode.addListener(() {
              if (receiverNameFocusNode.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            bankId.addListener(() {
              if (bankId.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            receiverPhone.addListener(() {
              if (receiverPhone.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 38,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: borderColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28),
                      result.rows!.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 24),
                              height: 62,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: result.rows!.asMap().entries.map(
                                    (entry) {
                                      final index = entry.key;
                                      final data = entry.value;
                                      return GestureDetector(
                                        key: ValueKey(index),
                                        onTap: () {
                                          setState(() {
                                            selectedContainerIndex = index;
                                          });
                                          receiverNameController.text =
                                              data.name;
                                          receiverBankController.text =
                                              data.bankName;
                                          bankIdController.text =
                                              data.bankCardNo;
                                          receiverPhoneController.text =
                                              data.phone;
                                          setState(() {
                                            dropBankName = data.bankName;
                                          });

                                          print(dropBankName);
                                        },
                                        child: buildContainer(data, index),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            )
                          : SizedBox(),
                      AnimatedTextField(
                        controller: receiverNameController,
                        labelText: 'Хүлээн авагчийн овог, нэр',
                        name: 'receiver',
                        focusNode: receiverBank,
                        borderColor: dark,
                        colortext: dark,
                        suffixIcon: receiverBank.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  receiverNameController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: DropdownButtonFormField(
                          value: dropBankName,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              dropBankName = value;
                            });
                          },
                          dropdownColor: white,
                          elevation: 1,
                          focusColor: white,
                          decoration: InputDecoration(
                            labelText: 'Хүлээн авагчийн банк',
                            labelStyle: TextStyle(
                              color: hintText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6.5,
                            ),
                          ),
                          items: general.bankName!
                              .map(
                                (data) => DropdownMenuItem(
                                  value: data.code,
                                  child: Text(
                                    '${data.code}',
                                    style: TextStyle(
                                      color: dark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16),
                      AnimatedTextField(
                        controller: bankIdController,
                        labelText: 'Дансны дугаар',
                        name: 'cityName',
                        focusNode: bankId,
                        borderColor: dark,
                        colortext: dark,
                        suffixIcon: bankId.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  bankIdController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(height: 16),
                      AnimatedTextField(
                        controller: receiverPhoneController,
                        labelText: 'Харилцах утас',
                        name: 'idNumber',
                        focusNode: receiverPhone,
                        borderColor: dark,
                        colortext: dark,
                        suffixIcon: receiverPhone.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  receiverPhoneController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        onClick: () {
                          if (receiverNameController.text != "" &&
                              dropBankName != null &&
                              bankIdController.text != "" &&
                              receiverPhoneController.text != "") {
                            setState(() {
                              isSetUser = true;
                            });
                            updateReceiverBox(receiverNameController.text);
                            info.name = receiverNameController.text;
                            info.bankName = dropBankName;
                            info.bankCardNo = bankIdController.text;
                            info.phone = receiverPhoneController.text;
                            setState(() {
                              dropBankName = null;
                            });
                            Navigator.of(context).pop();
                          } else {
                            showErrorReceiver();
                          }
                        },
                        buttonColor: blue,
                        isLoading: false,
                        labelText: 'Болсон',
                        textColor: white,
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showErrorReceiver() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 75),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Амжилтгүй',
                      style: TextStyle(
                          color: dark,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 24,
                          fontFamily: "Montserrat"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Мэдээлэл дутуу байна.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Montserrat",
                        color: dark,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            "хаах",
                            style: TextStyle(
                                color: black, fontFamily: "Montserrat"),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Lottie.asset('assets/lottie/error.json',
                  height: 150, repeat: false),
            ],
          ),
        );
      },
    );
  }

  puposePayment(BuildContext context, General data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: borderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Divider(
                      color: borderColor,
                    ),
                    Column(
                      children: data.purposeTypes!
                          .map((data) => InkWell(
                                onTap: () {
                                  updatePurposePayment(data.name!);
                                  setState(() {
                                    purposeTrade = true;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        '${data.name}',
                                        style: TextStyle(
                                          color: borderBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: borderColor,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  confirm(BuildContext context, Receiver data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          final tools = Provider.of<ExchangeProvider>(context, listen: false);
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset('assets/svg/close.svg'),
                      ),
                      Text(
                        'Баталгаажуулалт',
                        style: TextStyle(
                          color: dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 40, height: 40),
                    ],
                  ),
                  SizedBox(height: 24),
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
                          Text(
                            '${data.name}',
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
                                  text: 'Дансны дугаар: ',
                                  style: TextStyle(
                                    color: dark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '${data.bankCardNo}',
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
                                  text: 'Банк: ',
                                  style: TextStyle(
                                    color: dark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '${data.bankName}',
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
                                  text: '${data.phone}',
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
                    height: 8,
                  ),
                  Text(
                    '1 JPY = ${dataReceive.toValue ?? 0} MNT',
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
                    'Шимтгэл:  ₮ ${Utils().formatCurrency(dataReceive.fee.toString()) ?? 0}',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Авах дүн:  ¥ ${dataReceive.toAmount ?? 0}',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Төлөх дүн: ₮ ${dataReceive.totalAmount ?? 0}',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    onClick: () {
                      setState(() {
                        confirmAll = true;
                      });
                      setState(
                        () {
                          tools.toUpdateUser(
                            newbank: data.bankName!,
                            newbankid: data.bankCardNo!,
                            newphone: data.phone!,
                            newreceiver: data.name!,
                          );
                          tools.updateAll(
                            newmnt: mntController.text,
                            newcurrency: jpnController.text,
                            newtoValue: dataReceive.toValue.toString(),
                            newtotalAmount: dataReceive.totalAmount.toString(),
                            newfee: dataReceive.fee.toString(),
                            newtoAmount: dataReceive.toAmount.toString(),
                          );
                        },
                      );
                      setState(() {
                        confirmAll = false;
                      });

                      Navigator.of(context).pop();
                      setState(() {
                        user.contract == false
                            ? termsofservice()
                            : Navigator.of(context).pushNamed(
                                SignaturePage.routeName,
                                arguments: SignaturePageArguments(
                                  pushedFrom: 'EXCHANGE',
                                ),
                              );
                      });
                    },
                    buttonColor: blue,
                    isLoading: confirmAll,
                    labelText: 'Баталгаажуулах',
                    textColor: white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  danVerify(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: borderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: grayBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Image.asset('assets/images/dan.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'ДАН Баталгаажуулалт',
                      style: TextStyle(
                        color: dark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Та ДАН Баталгаажуулалт хийснээр валют арилжаа, мөнгөн гуйвуулга хийх боломжтой болно.',
                      style: TextStyle(
                        color: dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                      onClick: () async {
                        setState(() {
                          danLoading = true;
                        });
                        Timer(Duration(seconds: 2), () async {
                          await UserApi().dan(user.id!);
                          setState(() {
                            danLoading = false;
                          });
                          user = await AuthApi().me(false);
                          Navigator.of(context).pop();
                          showSuccess(context);
                        });
                      },
                      buttonColor: blue,
                      isLoading: danLoading,
                      labelText: 'Баталгаажуулах',
                      textColor: white,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showSuccess(ctx) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 75),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Амжилттай',
                      style: TextStyle(
                          color: dark,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Дан амжилттай баталгаажлаа.',
                      textAlign: TextAlign.center,
                    ),
                    ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            "хаах",
                            style: TextStyle(color: dark),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Lottie.asset('assets/lottie/success.json',
                  height: 150, repeat: false),
            ],
          ),
        );
      },
    );
  }

  bool danLoading = false;
  termsofservice() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: dark,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Үйлчилгээний нөхцөл',
                    style: TextStyle(
                      color: dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          'Egulen POS -Ухаалаг кассын систем ньресторан, зоогийн газар, дэлгүүр, эмнэлэг,гоо сайхны салон зэрэг худалдааүйлчилгээний газарт зориулагдсан багцбүтээгдэхүүн юм.Энэхүү үйлчилгээнийнөхцөл нь Egulen POS —Уxaanar кассынсистемийг ашиглан үйлчилгээ авахтайхолбоотой үүсэх харилцааг зохицуулна.Энэхүү нөхцөл нь хэрэг эгчөмнө уншиж танилцан хүлээн зөвшөөрчбаталгаажуулсны үндсэн дээр хэрэгжинэ Үйлчилгээний нөхцөлийн хэрэгжилтэд өгүүлэнСистем ХХК /цаашид байгууллага гэх/ болонхэрэглэгч /цаашид хэрэглэгч гэх/ хамтранхяналт тавинаНЭГ. Хэрэглэгчийн эрх үүрэгХэрэглэгч нь iРаd хэрэглэгч байх бөгөөдинтернэт (36 эсвэл W-Fi) холболттой байнаХэрэглэгч үйлчилгээг ашиглахтай холбоотойгарын авлага, сургалтыг авах боломжтойХэрэглэгч үйлчилгээний чанар, системийнажиллагааны талаар санал хүсэлт, гомдол,талархлаа хэлэх эрхтэйEgulen POS -Ухаалаг кассын систем ньресторан, зоогийн газар, дэлгүүр, эмнэлэг,гоо сайхны салон зэрэг худалдааүйлчилгээний газарт зориулагдсан багцбүтээгдэхүүн юм.Энэхүү үйлчилгэvэнийнөхцөл нь Egulen POS —Уxaanar кассынсистемийг ашиглан үйлчилгээ авахтайхолбоотой үүсэх харилцааг зохицуулна.Энэхүү нөхцөл нь хэрэг эгчөмнө уншиж танилцан хүлээн зөвшөөрчбаталгаажуулсны үндсэн дээр хэрэгжинэ Үйлчилгээний нөхцөлийн хэрэгжилтэд өгүүлэнСистем ХХК /цаашид байгууллага гэх/ болонхэрэглэгч /цаашид хэрэглэгч гэх/ хамтранхяналт тавинаНЭГ. Хэрэглэгчийн эрх үүрэг                  Egulen POS -Ухаалаг кассын систем ньресторан, зоогийн газар, дэлгүүр, эмнэлэг,гоо сайхны салон зэрэг худалдааүйлчилгээний газарт зориулагдсан багцбүтээгдэхүүн юм.Энэхүү үйлчилгээнийнөхцөл нь Egulen POS —Уxaanar кассынсистемийг ашиглан үйлчилгээ авахтайхолбоотой үүсэх харилцааг зохицуулна.Энэхүү нөхцөл нь хэрэг эгчөмнө уншиж танилцан хүлээн зөвшөөрчбаталгаажуулсны үндсэн дээр хэрэгжинэ Үйлчилгээний нөхцөлийн хэрэгжилтэд өгүүлэнСистем ХХК /цаашид байгууллага гэх/ болонхэрэглэгч /цаашид хэрэглэгч гэх/ хамтранхяналт тавинаНЭГ. Хэрэглэгчийн эрх үүрэгХэрэглэгч нь iРаd хэрэглэгч байх бөгөөдинтернэт (36 эсвэл W-Fi) холболттой байнаХэрэглэгч үйлчилгээг ашиглахтай холбоотойгарын авлага, сургалтыг авах боломжтойХэрэглэгч үйлчилгээний чанар, системийнажиллагааны талаар санал хүсэлт, гомдол,талархлаа хэлэх эрхтэйEgulen POS -Ухаалаг кассын систем ньресторан, зоогийн газар, дэлгүүр, эмнэлэг,гоо сайхны салон зэрэг худалдааүйлчилгээний газарт зориулагдсан багцбүтээгдэхүүн юм.Энэхүү үйлчилгэvэнийнөхцөл нь Egulen POS —Уxaanar кассынсистемийг ашиглан үйлчилгээ авахтайхолбоотой үүсэх харилцааг зохицуулна.Энэхүү нөхцөл нь хэрэг эгчөмнө уншиж танилцан хүлээн зөвшөөрчбаталгаажуулсны үндсэн дээр хэрэгжинэ Үйлчилгээний нөхцөлийн хэрэгжилтэд өгүүлэнСистем ХХК /цаашид байгууллага гэх/ болонхэрэглэгч /цаашид хэрэглэгч гэх/ хамтранхяналт тавинаНЭГ. Хэрэглэгчийн эрх үүрэг',
                          style: TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  confirmterm = !confirmterm;
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 1,
                                    color: checkColor,
                                  ),
                                ),
                                child: confirmterm == true
                                    ? SvgPicture.asset(
                                        'assets/svg/remember.svg')
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Би зөвшөөрч байна',
                              style: TextStyle(
                                color: black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                          onClick: () {
                            confirmterm == true
                                ? Navigator.of(context).pushNamed(
                                    SignaturePage.routeName,
                                    arguments: SignaturePageArguments(
                                      pushedFrom: 'EXCHANGE',
                                    ),
                                  )
                                : () {};
                          },
                          buttonColor: blue,
                          isLoading: false,
                          labelText: 'Үргэлжлүүлэх',
                          textColor: white,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
