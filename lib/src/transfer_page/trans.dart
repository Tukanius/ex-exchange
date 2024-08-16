// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
import 'package:wx_exchange_flutter/src/exchange_page/signature/signature_page.dart';
import 'package:wx_exchange_flutter/src/history_page/transfer_detail.dart';
import 'package:wx_exchange_flutter/utils/currency_formatter.dart';
import 'package:wx_exchange_flutter/utils/utils.dart';
// import 'package:wx_exchange_flutter/utils/utils.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<TransferPage> with AfterLayoutMixin {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
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
  // final Utils _utils = Utils();
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
  void initState() {
    super.initState();
    bankName.addListener(_onFocusChange);
    accountNumber.addListener(_onFocusChange);
    swiftCode.addListener(_onFocusChange);
    branchName.addListener(_onFocusChange);
    branchAddress.addListener(_onFocusChange);
    accountName.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }
  // void _formatInput() {
  //   // Get the raw input from the controller
  //   String rawText = mntController.text;

  //   // Format the input using the updated formatCurrency method
  //   String formattedText = _utils.formatCurrency(rawText);

  //   // Update the text with the formatted value
  //   mntController.value = TextEditingValue(
  //     text: formattedText,
  //     selection: TextSelection.collapsed(offset: formattedText.length),
  //   );
  // }

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
    Filter filter = Filter(type: 'TRANSFER');
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
    Filter filter = Filter(type: 'TRANSFER');
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
        isValueError = num.parse(cleanValue) < general.minMax!.min!;
        isValueErrorLimit = num.parse(cleanValue) > general.minMax!.max!;
        print(isValueErrorLimit);
        print(isValueError);
      });
      Exchange data = Exchange();
      if (timer != null) timer!.cancel();
      setState(() {
        tradeSubmit = true;
      });
      timer = Timer(const Duration(milliseconds: 500), () async {
        if (!mounted) return;
        try {
          data.type = "TRANSFER";
          data.fromCurrency = "JPY";
          data.toCurrency = "MNT";
          data.fromAmount = num.parse(cleanValue);
          num.parse(cleanValue) >= general.minMax!.min!
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
  @override
  void dispose() {
    timer?.cancel();
    bankName.removeListener(_onFocusChange);
    accountNumber.removeListener(_onFocusChange);
    swiftCode.removeListener(_onFocusChange);
    branchName.removeListener(_onFocusChange);
    branchAddress.removeListener(_onFocusChange);
    accountName.removeListener(_onFocusChange);

    bankName.dispose();
    accountNumber.dispose();
    swiftCode.dispose();
    branchName.dispose();
    branchAddress.dispose();
    accountName.dispose();
    super.dispose();
  }

  bool isValueError = false;
  bool isSetUser = true;
  bool purposeTrade = true;

  verify() async {
    if (user.userStatus == "NEW") {
      danVerify(context);
      // VERIFIED
    } else {
      if (isValueError == false) {
        setState(() {
          print(mntController.text);
          var res = mntController.text.replaceAll(',', '');
          num.parse(res) >= general.minMax!.min!
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

      if (isValueError == false &&
          isValueErrorLimit == false &&
          isSetUser == true &&
          purposeTrade == true) {
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
                              'Мөнгөн гуйвуулга',
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
                                  floatLabel: FloatingLabelBehavior.always,
                                  onChanged: (query) {
                                    onChange(query);
                                  },
                                  onComplete: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  autoFocus: false,
                                  labelText: 'Илгээх дүн',
                                  name: 'mnt',
                                  focusNode: mnt,
                                  borderColor: isValueError ? redError : blue,
                                  colortext: dark,
                                  hintText: '¥ 0',
                                  hintTextColor: hintColor,
                                  inputType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    ThousandsSeparatorFormatter(),
                                  ],
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
                                        'Гуйвуулгын хамгийн бага дүн ¥ ${Utils().formatTextCustom(general.minMax!.min)}.',
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
                                        'Гуйвуулгын дүнгийн лимит хэтэрсэн',
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
                                  labelText: 'Дүн',
                                  name: 'yen',
                                  autoFocus: false,
                                  focusNode: yen,
                                  borderColor: blue,
                                  colortext: dark,
                                  hintText: '₮ 0',
                                  hintTextColor: hintColor,
                                  controller: jpnController,
                                  onComplete: () {
                                    FocusScope.of(context).unfocus();
                                  },
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
                          '1 JPY = ${general.jpyCurrency?.sell ?? 0} MNT',
                          style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Шимтгэл: ₮ ${Utils().formatTextCustom(dataReceive.fee ?? 0)}',
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
                          labelText: 'Гуйвуулга хийх',
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
                                                TransferDetailPage.routeName,
                                                arguments:
                                                    TransferDetailPageArguments(
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

  FocusNode bankName = FocusNode();
  FocusNode accountNumber = FocusNode();
  FocusNode swiftCode = FocusNode();
  FocusNode branchName = FocusNode();
  FocusNode branchAddress = FocusNode();
  FocusNode accountName = FocusNode();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController branchAddressController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  int selectedContainerIndex = -1;

  addReceiver(BuildContext context, General general) {
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // bankName.addListener(() {
            //   if (bankName.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
            // accountNumber.addListener(() {
            //   if (accountNumber.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
            // swiftCode.addListener(() {
            //   if (swiftCode.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
            // branchName.addListener(() {
            //   if (branchName.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
            // branchAddress.addListener(() {
            //   if (branchAddress.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
            // accountName.addListener(() {
            //   if (accountName.hasFocus) {
            //     setState(() {});
            //   } else {
            //     setState(() {});
            //   }
            // });
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
                                            if (selectedContainerIndex ==
                                                index) {
                                              selectedContainerIndex = -1;
                                              bankNameController.clear();
                                              accountNumberController.clear();
                                              swiftCodeController.clear();
                                              branchNameController.clear();
                                              branchAddressController.clear();
                                              accountNameController.clear();
                                            } else {
                                              selectedContainerIndex = index;
                                              bankNameController.text =
                                                  data.bankName;
                                              accountNumberController.text =
                                                  data.accountNumber;
                                              swiftCodeController.text =
                                                  data.swiftCode;
                                              branchNameController.text =
                                                  data.branchName;
                                              branchAddressController.text =
                                                  data.branchAddress;
                                              accountNameController.text =
                                                  data.accountName;
                                            }
                                          });
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
                              controller: bankNameController,
                              labelText: 'Bank name:',
                              name: 'bankName',
                              focusNode: bankName,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: bankName.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        bankNameController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateName(value.toString());
                                }
                              ]),
                            ),
                            SizedBox(height: 16),
                            AnimatedTextField(
                              controller: accountNumberController,
                              labelText: 'Account number:',
                              name: 'accountNumber',
                              focusNode: accountNumber,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: accountNumber.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        accountNumberController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateNumber(value.toString());
                                }
                              ]),
                            ),
                            SizedBox(height: 16),
                            AnimatedTextField(
                              controller: swiftCodeController,
                              labelText: 'Swift code:',
                              name: 'swiftCode',
                              focusNode: swiftCode,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: swiftCode.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        swiftCodeController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateName(value.toString());
                                }
                              ]),
                            ),
                            SizedBox(height: 16),
                            AnimatedTextField(
                              controller: branchNameController,
                              labelText: 'Branch name:',
                              name: 'branchName',
                              focusNode: branchName,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: branchName.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        branchNameController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateName(value.toString());
                                }
                              ]),
                            ),
                            SizedBox(height: 16),
                            AnimatedTextField(
                              controller: branchAddressController,
                              labelText: 'Branch address:',
                              name: 'branchAddress',
                              focusNode: branchAddress,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: branchAddress.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        branchAddressController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateName(value.toString());
                                }
                              ]),
                            ),
                            SizedBox(height: 16),
                            AnimatedTextField(
                              controller: accountNameController,
                              labelText: 'Account name:',
                              name: 'accountName',
                              focusNode: accountName,
                              borderColor: blue,
                              colortext: dark,
                              suffixIcon: accountName.hasFocus == true
                                  ? GestureDetector(
                                      onTap: () {
                                        accountNameController.clear();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: black,
                                      ),
                                    )
                                  : null,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  return validateName(value.toString());
                                }
                              ]),
                            ),
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
                          color: grayAccent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Үйлчлүүлэгч та гуйвуулга хийх банкны мэдээллээ сайтар шалгаж илгээнэ үү!',
                            style: TextStyle(
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomButton(
                        onClick: () {
                          if (fbkey.currentState!.saveAndValidate()) {
                            if (bankNameController.text != "" &&
                                accountNumberController.text != "" &&
                                swiftCodeController.text != "" &&
                                branchNameController.text != "" &&
                                branchAddressController.text != "" &&
                                accountNameController.text != "") {
                              setState(() {
                                isSetUser = true;
                              });
                              updateReceiverBox(accountNameController.text);
                              info.bankName = bankNameController.text;
                              info.accountNumber = accountNumberController.text;
                              info.swiftCode = swiftCodeController.text;
                              info.branchName = branchNameController.text;
                              info.branchAddress = branchAddressController.text;
                              info.accountName = accountNameController.text;
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
                            FocusScope.of(context).unfocus();
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
                            FocusScope.of(context).unfocus();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
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
                                    '${data.bankName}',
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
                                    '${data.swiftCode}',
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
                                    '${data.branchName}',
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
                                    '${data.branchAddress}',
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
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(16),
                    //     border: Border.all(width: 1, color: borderColor),
                    //   ),
                    //   child: Padding(
                    //     padding: EdgeInsets.all(16),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Bank name: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.bankName}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Account number: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.accountNumber}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Swift code: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.swiftCode}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Branch name: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.branchName}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Branch address: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.branchAddress}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Account name: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${data.accountName}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 8,
                    //         ),
                    //         RichText(
                    //           text: TextSpan(
                    //             children: [
                    //               TextSpan(
                    //                 text: 'Төлбөрийн зориулалт: ',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //               TextSpan(
                    //                 text: '${purpose}',
                    //                 style: TextStyle(
                    //                   color: dark,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                      'Шимтгэл:  ₮ ${Utils().formatTextCustom(dataReceive.fee ?? 0)}',
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
                      'Гуйвуулах дүн: ¥ ${mntController.text}',
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
                      'Нийт төлөх дүн: ₮ ${Utils().formatCurrencyCustom(dataReceive.totalAmount ?? 0)}',
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
                        try {
                          setState(() {
                            confirmAll = true;
                          });
                          setState(
                            () {
                              tools.toUpdateTransfer(
                                newBankName: data.bankName!,
                                newAccountNumber: data.accountNumber!,
                                newSwiftCode: data.swiftCode!,
                                newBranchName: data.branchName!,
                                newBranchAddress: data.branchAddress!,
                                newAccountName: data.accountName!,
                                newPurpose: purpose,
                              );
                              final res =
                                  mntController.text.replaceAll(',', '');

                              tools.updateAll(
                                newmnt: num.parse(res),
                                newcurrency: jpnController.text,
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
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            user.contract == false
                                ? termsofservice()
                                : Navigator.of(context).pushNamed(
                                    SignaturePage.routeName,
                                    arguments: SignaturePageArguments(
                                      pushedFrom: 'TRANSFER',
                                    ),
                                  );
                          });
                        } catch (e) {
                          setState(() {
                            confirmAll = false;
                          });
                          print(e.toString());
                        }
                      },
                      buttonColor: blue,
                      isLoading: confirmAll,
                      labelText: 'Баталгаажуулах',
                      textColor: white,
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
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
                      isLoading: false,
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

  bool danLoading = false;
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
                                      pushedFrom: 'TRANSFER',
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

String? validatePhone(String value) {
  RegExp regex = RegExp(r'^[0-9]{8,12}$');
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

String? validateNumber(String value) {
  if (value.isEmpty) {
    return "Талбарыг заавал бөглөнө үү";
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Зөвхөн тоо оруулна уу";
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
