// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wx_exchange_flutter/api/auth_api.dart';
import 'package:wx_exchange_flutter/api/exchange_api.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/controller/listen.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/components/history_button/history_button.dart';
import 'package:wx_exchange_flutter/components/loader/loader.dart';
import 'package:wx_exchange_flutter/models/contract.dart';
import 'package:wx_exchange_flutter/models/exchange.dart';
import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/models/jpy_currency.dart';
import 'package:wx_exchange_flutter/models/receiver.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/exchange_provider.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/src/exchange_page/signature/signature_page.dart';
import 'package:wx_exchange_flutter/src/history_page/exchange.dart';
import 'package:wx_exchange_flutter/utils/currency_formatter.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> with AfterLayoutMixin {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();

  FocusNode mnt = FocusNode();
  FocusNode yen = FocusNode();
  bool confirmterm = false;
  Receiver info = Receiver();
  bool confirmAll = false;
  String? dropBankName;
  bool isLoading = true;
  bool isLoadingHistory = true;
  bool isLoadingData = true;
  Timer? timer;
  String convertedValue = '0';
  Exchange dataReceive = Exchange();
  int page = 1;
  int limit = 10;
  int pageHistory = 1;
  int limitHistory = 15;
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
  Contract contract = Contract();
  String html = '''''';
  JpyCurrency currencyBuy = JpyCurrency();
  JpyCurrency currencySell = JpyCurrency();
  ListenController listenController = ListenController();
  bool index = true;

  @override
  void initState() {
    super.initState();
    receiverNameFocusNode.addListener(_onFocusChange);
    bankIdFocus.addListener(_onFocusChange);
    receiverPhoneFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    receiverNameFocusNode.removeListener(_onFocusChange);
    bankIdFocus.removeListener(_onFocusChange);
    receiverPhoneFocus.removeListener(_onFocusChange);

    receiverNameFocusNode.dispose();
    bankIdFocus.dispose();
    receiverPhoneFocus.dispose();
    super.dispose();
  }

  @override
  afterFirstLayout(BuildContext context) async {
    user = await AuthApi().me(false);

    try {
      await list(page, limit);
      await listHistory(page, limit);
      contract = await UserApi().getContract();
      currencyBuy.type = 'EXCHANGE';
      currencyBuy.currency = 'JPY';
      currencyBuy.getType = "BUY";
      currencyBuy = await ExchangeApi().getRate(currencyBuy);
      currencySell.type = 'EXCHANGE';
      currencySell.currency = 'JPY';
      currencySell.getType = "SELL";
      currencySell = await ExchangeApi().getRate(currencySell);
      print('=============get===========');
      print(currencyBuy.get);
      print('=============get===========');

      html = '''${contract.description}''';
      setState(() {
        isLoadingData = false;
      });
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoadingHistory = false;
          isLoadingData = false;
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

  bool isValueErrorLimit = false;

  onChange(String query) async {
    print('=======query======');
    final cleanValue = query.replaceAll(',', '');
    print(cleanValue);
    print('=======query======');

    if (cleanValue != '') {
      setState(() {
        isEmpty = false;

        if (num.parse(cleanValue) ==
            (index == true ? currencyBuy.minLimit : currencySell.minLimit))
          isValueError = false;
        if (num.parse(cleanValue) ==
            (index == true ? currencyBuy.maxLimit : currencySell.maxLimit))
          isValueErrorLimit = false;
        isValueError = num.parse(cleanValue) <
            (index == true ? currencyBuy.minLimit! : currencySell.minLimit!);
        isValueErrorLimit = num.parse(cleanValue) >
            (index == true ? currencyBuy.maxLimit! : currencySell.maxLimit!);
        print(isValueError);
        print(isValueErrorLimit);
      });
      Exchange data = Exchange();
      if (timer != null) timer!.cancel();
      setState(() {
        tradeSubmit = true;
      });
      timer = Timer(const Duration(milliseconds: 500), () async {
        if (!mounted) return;
        try {
          data.type = "EXCHANGE";
          data.fromCurrency = "JPY";
          data.toCurrency = "MNT";
          data.fromAmount = num.parse(cleanValue);
          data.getType = index == true ? "BUY" : "SELL";
          num.parse(cleanValue) >=
                  (index == true
                      ? currencyBuy.minLimit
                      : currencySell.minLimit)!
              ? dataReceive = await ExchangeApi().tradeConvertor(data)
              : SizedBox();
          if (!mounted) return;
          setState(() {
            jpnController.text =
                Utils().formatTextCustom(dataReceive.toAmount ?? 0);
          });
          setState(() {
            tradeSubmit = false;
          });
          if (isValueError == true) {
            jpnController.text = '0';
            dataReceive.fee = 0;
            dataReceive.toValue = 0;
          }
          if (isValueErrorLimit == true) {
            jpnController.text = '0';
            dataReceive.fee = 0;
            dataReceive.toValue = 0;
          }
        } catch (e) {
          print(e.toString());
          if (mounted) {
            setState(() {
              jpnController.text = '0';
              dataReceive.fee = 0;
              dataReceive.toValue = 0;
            });
            setState(() {
              tradeSubmit = false;
            });
          }
        }
      });
    } else {
      setState(() {
        jpnController.text = '0';
        dataReceive.fee = 0;
        dataReceive.toValue = 0;
      });
    }
  }

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

  bool isValueError = false;
  bool isSetUser = true;
  bool purposeTrade = true;
  bool isEmpty = false;

  verify() async {
    if (user.userStatus == "NEW") {
      danVerify(context);
    } else {
      print('===========focus==========');
      print(mntController.text);
      print('===========focus==========');

      if (mntController.text == "") {
        setState(() {
          isEmpty = true;
        });
      }
      // if (isValueError == false) {
      //   setState(() {
      //     print(mntController.text);
      //     var res = mntController.text.replaceAll(',', '');
      //     num.parse(res) >= general.minMax!.min!
      //         ? isValueError = false
      //         : isValueError = true;
      //     print(isValueError);
      //   });
      // }

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

      if (isValueError == false &&
          isValueErrorLimit == false &&
          isSetUser == true &&
          purposeTrade == true &&
          isEmpty == false) {
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

  void updateBankName(String name) {
    setState(() {
      updatedBankName = name;
    });
  }

  String updatedBankName = '';

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
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      index = true;
                                      mntController.clear();
                                      jpnController.text = '0';
                                      dataReceive.fee = 0;
                                      dataReceive.toValue = 0;
                                    });
                                    // currency.type = 'EXCHANGE';
                                    // currency.currency = 'JPY';
                                    // currency.getType = "BUY";
                                    // currency =
                                    //     await ExchangeApi().getRate(currency);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: index == true
                                          ? blue.withOpacity(0.1)
                                          : white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Валют авах',
                                        style: TextStyle(
                                          color: index == true ? blue : dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      index = false;
                                      mntController.clear();
                                      jpnController.text = '0';
                                      dataReceive.fee = 0;
                                      dataReceive.toValue = 0;
                                    });
                                    // currency.type = 'EXCHANGE';
                                    // currency.currency = 'JPY';
                                    // currency.getType = "SELL";
                                    // currency =
                                    //     await ExchangeApi().getRate(currency);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: index == false
                                          ? blue.withOpacity(0.1)
                                          : white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Валют зарах',
                                        style: TextStyle(
                                          color: index == false ? blue : dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  floatLabel: FloatingLabelBehavior.always,
                                  onChanged: (query) {
                                    onChange(query);
                                  },
                                  labelText: 'Иен',
                                  name: 'mnt',
                                  focusNode: mnt,
                                  borderColor: isValueError ? redError : blue,
                                  colortext: dark,
                                  hintText: '¥0',
                                  hintTextColor: hintColor,
                                  inputType: TextInputType.number,
                                  controller: mntController,
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
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    ThousandsSeparatorFormatter(),
                                  ],
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
                                        'Арилжих хамгийн бага утга ¥ ${Utils().formatTextCustom(index == true ? currencyBuy.minLimit : currencySell.minLimit)}.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: redError,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              isValueErrorLimit == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 32,
                                        right: 16,
                                        top: 4,
                                      ),
                                      child: Text(
                                        'Арилжих дүнгийн лимит хэтэрсэн',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: redError,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              isEmpty == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 32,
                                        right: 16,
                                        top: 4,
                                      ),
                                      child: Text(
                                        'Арилжих дүн оруулна уу.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: redError,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
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
                                  labelText: 'Төгрөг',
                                  name: 'yen',
                                  focusNode: yen,
                                  borderColor: blue,
                                  colortext: dark,
                                  controller: jpnController,
                                  hintText: '₮0',
                                  hintTextColor: hintColor,
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
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          isLoadingData == true
                              ? '1 JPY = 0 MNT'
                              : '1 JPY = ${index == true ? currencyBuy.sell : currencyBuy.get} MNT',
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
                          'Шимтгэл: ₮ ${Utils().formatTextCustom(dataReceive.fee ?? 0)}',
                          style: TextStyle(
                            color: dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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
                                                  listenController:
                                                      listenController,
                                                  notifyData: '',
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
                        //     child: isLoadingHistory
                        //         ? Center(
                        //             child: CircularProgressIndicator(
                        //               color: blue,
                        //             ),
                        //           )
                        //         : resultHistory.rows!.isNotEmpty
                        //             ? ListView.builder(
                        //                 itemCount: resultHistory.rows!.length,
                        //                 itemBuilder: (context, index) {
                        //                   final data =
                        //                       resultHistory.rows![index];
                        //                   return GestureDetector(
                        //                     onTap: () {
                        //                        Navigator.of(context).pushNamed(
                        //                           OrderDetailPage.routeName,
                        //                           arguments:
                        //                               OrderDetailPageArguments(
                        //                                   data: data),
                        //                         );
                        //                       // if (data.type == "TRANSFER") {
                        //                       //   Navigator.of(context).pushNamed(
                        //                       //     TransferDetailPage.routeName,
                        //                       //     arguments:
                        //                       //         TransferDetailPageArguments(
                        //                       //             data: data),
                        //                       //   );
                        //                       // } else {

                        //                       // }
                        //                     },
                        //                     child:
                        //                         TradeHistoryButton(data: data),
                        //                   );
                        //                 },
                        //               )
                        //             : Center(
                        //                 child: Column(
                        //                   children: [
                        //                     SizedBox(
                        //                       height: 80,
                        //                     ),
                        //                     SvgPicture.asset(
                        //                       'assets/svg/notfound.svg',
                        //                       color: dark,
                        //                     ),
                        //                     SizedBox(
                        //                       height: 15,
                        //                     ),
                        //                     Text(
                        //                       'Түүх олдсонгүй.',
                        //                       style: TextStyle(
                        //                         color: dark,
                        //                         fontSize: 14,
                        //                         fontWeight: FontWeight.w600,
                        //                       ),
                        //                     ),
                        //                     SizedBox(
                        //                       height: 80,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
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

  FocusNode receiverNameFocusNode = FocusNode();
  FocusNode bankIdFocus = FocusNode();
  FocusNode receiverPhoneFocus = FocusNode();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController bankIdController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();

  addReceiver(BuildContext context, General general) {
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
                selectedContainerIndex == index
                    ? SvgPicture.asset(
                        'assets/svg/check.svg',
                      )
                    : SvgPicture.asset(
                        'assets/svg/uncheck.svg',
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
                        '${data.accountName}',
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
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
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
                                          // Toggle selection
                                          if (selectedContainerIndex == index) {
                                            selectedContainerIndex = -1;
                                            receiverNameController.clear();
                                            receiverPhoneController.clear();
                                            bankIdController.clear();
                                            setState(() {
                                              dropBankName = null;
                                            });
                                          } else {
                                            selectedContainerIndex = index;
                                            receiverPhoneController.text =
                                                data.phone;
                                            bankIdController.text =
                                                data.accountNumber;
                                            receiverNameController.text =
                                                data.accountName;
                                            setState(() {
                                              dropBankName = data.bankName;
                                              updatedBankName =
                                                  getBankName(data.bankName);
                                            });
                                          }
                                        });
                                        // setState(() {
                                        //   selectedContainerIndex = index;
                                        // });
                                        // receiverNameController.text =
                                        //     data.accountName;
                                        // bankIdController.text =
                                        //     data.accountNumber;
                                        // receiverPhoneController.text =
                                        //     data.phone;

                                        // print(dropBankName);
                                      },
                                      child: buildContainer(data, index),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          )
                        : SizedBox(),
                    FormBuilder(
                      key: fbkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextField(
                            inputType: TextInputType.text,
                            controller: receiverNameController,
                            labelText: 'Хүлээн авагчийн овог, нэр',
                            name: 'accountName',
                            focusNode: receiverNameFocusNode,
                            borderColor: blue,
                            colortext: dark,
                            suffixIcon: receiverNameFocusNode.hasFocus == true
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
                            validator: FormBuilderValidators.compose([
                              (value) {
                                return isValidCryllic(
                                    value.toString(), context);
                              }
                            ]),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField(
                            value: dropBankName,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropBankName = value;
                                updatedBankName = getBankName(value!);
                              });
                            },
                            dropdownColor: white,
                            elevation: 1,
                            focusColor: white,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: cancel),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: cancel),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: blue),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: blue),
                              ),
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
                                vertical: 12,
                              ),
                            ),
                            items: general.bankNames!
                                .map(
                                  (data) => DropdownMenuItem(
                                    value: data.code,
                                    child: Text(
                                      '${data.name}',
                                      style: TextStyle(
                                        color: dark,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Банк сонгоно уу';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          AnimatedTextField(
                            controller: bankIdController,
                            labelText: 'Дансны дугаар',
                            name: 'accountNumber',
                            focusNode: bankIdFocus,
                            borderColor: blue,
                            colortext: dark,
                            inputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            suffixIcon: bankIdFocus.hasFocus == true
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
                            validator: FormBuilderValidators.compose([
                              (value) {
                                return validateDans(value.toString());
                              }
                            ]),
                          ),
                          SizedBox(height: 16),
                          AnimatedTextField(
                            controller: receiverPhoneController,
                            labelText: 'Харилцах утас',
                            name: 'phone',
                            focusNode: receiverPhoneFocus,
                            borderColor: blue,
                            colortext: dark,
                            inputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            suffixIcon: receiverPhoneFocus.hasFocus == true
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
                            validator: FormBuilderValidators.compose([
                              (value) {
                                return validatePhone(value.toString());
                              }
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomButton(
                      onClick: () {
                        if (fbkey.currentState!.saveAndValidate()) {
                          if (receiverNameController.text != "" &&
                              dropBankName != null &&
                              bankIdController.text != "" &&
                              receiverPhoneController.text != "") {
                            setState(() {
                              isSetUser = true;
                            });
                            updateReceiverBox(receiverNameController.text);
                            info.accountName = receiverNameController.text;
                            info.bankName = dropBankName;
                            info.accountNumber = bankIdController.text;
                            info.phone = receiverPhoneController.text;

                            setState(() {
                              dropBankName = null;
                            });
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                          }
                        }
                      },
                      buttonColor: blue,
                      isLoading: false,
                      labelText: 'Болсон',
                      textColor: white,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
                                  FocusScope.of(context).unfocus();
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
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
                                  '${data.accountName}',
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
                                  '${updatedBankName}',
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
                                  '${data.accountNumber}',
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
                                  '${data.phone}',
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
                                  '${purpose}',
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
                  index == true
                      ? Text(
                          'Авах дүн: ¥ ${mntController.text}',
                          style: TextStyle(
                            color: dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Зарах дүн: ¥ ${mntController.text}',
                              style: TextStyle(
                                color: dark,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Шимтгэл: ₮ ${Utils().formatTextCustom(dataReceive.fee)}',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  index == true
                      ? Text(
                          'Төлөх дүн: ${index == true ? '₮' : '¥'} ${Utils().formatCurrencyCustom(dataReceive.totalAmount ?? 0)}',
                          style: TextStyle(
                            color: dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          'Авах дүн: ₮ ${Utils().formatCurrencyCustom(dataReceive.totalAmount ?? 0)}',
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
                            newbankid: data.accountNumber!,
                            newphone: data.phone!,
                            newreceiver: data.accountName!,
                            newexchangePurpose: purpose,
                          );
                          final res = mntController.text.replaceAll(',', '');
                          final res1 = jpnController.text.replaceAll(',', '');

                          tools.updateAll(
                            isSell: index == true ? true : false,
                            newmnt: num.parse(res),
                            newcurrency: num.parse(res1),
                            newtoValue: dataReceive.toValue.toString(),
                            newtotalAmount: dataReceive.totalAmount!,
                            newfee: dataReceive.fee!,
                            newtoAmount: dataReceive.toAmount.toString(),
                          );
                        },
                      );
                      setState(() {
                        confirmAll = false;
                      });
                      Navigator.of(context).pop();
                      FocusScope.of(context).unfocus();
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
                  SizedBox(
                    height: 24,
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
                        Html(
                          data: html,
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

String? isValidCryllic(String name, BuildContext context) {
  String pattern = r'(^[а-яА-ЯӨөҮүЁёӨө -]+$)';
  RegExp isValidName = RegExp(pattern);
  if (name.isEmpty) {
    return "Заавар оруулна";
  } else {
    if (!isValidName.hasMatch(name)) {
      return "Зөвхөн крилл үсэг ашиглана";
    } else {
      return null;
    }
  }
}

String? validatePhone(String value) {
  RegExp regex = RegExp(r'^[689][0-9]{7}$');
  if (value.isEmpty) {
    return 'Утасны дугаараа оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Утасны дугаараа шалгана уу';
    } else {
      return null;
    }
  }
}

String? validateName(String value) {
  if (value.isEmpty) {
    return "Талбарыг заавал бөглөнө үү";
  }
  return null;
}

String? validateDans(String value) {
  String pattern = r'^[0-9]{8,12}$';
  RegExp regex = RegExp(pattern);

  if (value.isEmpty) {
    return "Талбарыг заавал бөглөнө үү";
  } else if (!regex.hasMatch(value)) {
    return "Утга нь 8-12 тоо байх ёстой";
  }
  return null; // Valid input
}
