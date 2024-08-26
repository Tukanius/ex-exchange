// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/components/refresher/refresher.dart';
import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/models/receiver.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ReceiverSettingsPage extends StatefulWidget {
  static const routeName = "ReceiverSettingsPage";
  const ReceiverSettingsPage({super.key});

  @override
  State<ReceiverSettingsPage> createState() => _ReceiverSettingsPageState();
}

class _ReceiverSettingsPageState extends State<ReceiverSettingsPage>
    with AfterLayoutMixin {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();

  int page = 1;
  int limit = 10;
  Result result = Result();
  bool isLoading = true;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  General general = General();
  String? dropBankName;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    try {
      await list(page, limit);
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  list(page, limit) async {
    Offset offset = Offset(page: page, limit: limit);
    Filter filter = Filter();
    result = await UserApi().getReceiver(
      ResultArguments(filter: filter, offset: offset),
    );
    setState(() {
      isLoading = false;
    });
  }

  onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoading = true;
    });
    await list(page, limit);
    refreshController.refreshCompleted();
  }

  onLoading() async {
    setState(() {
      limit += 10;
    });
    await list(page, limit);
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    general = Provider.of<GeneralProvider>(context, listen: false).general;
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
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark,
          ),
        ),
        title: Text(
          'Хүлээн авагчийн жагсаалт',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: Refresher(
        color: blue,
        refreshController: refreshController,
        onLoading: onLoading,
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: blue,
                        ),
                      )
                    : result.rows!.isNotEmpty
                        ? Column(
                            children: result.rows!
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      e.type == "EXCHANGE"
                                          ? editReceiver(context, general, e)
                                          : editTransReceiver(context, e);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                        border: Border.all(color: borderColor),
                                      ),
                                      margin: EdgeInsets.only(bottom: 8),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 13,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/svg/check.svg'),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Хүлээн авагч',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: hintText,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${e.accountName}',
                                                      style: TextStyle(
                                                        color: dark,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SvgPicture.asset(
                                                'assets/svg/edit.svg'),
                                          ],
                                        ),
                                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  editReceiver(BuildContext context, General general, Receiver data) {
    FocusNode receiverNameFocusNode = FocusNode();
    FocusNode bankIdFocus = FocusNode();
    FocusNode receiverPhoneFocus = FocusNode();
    TextEditingController receiverNameController = TextEditingController();
    TextEditingController bankIdController = TextEditingController();
    TextEditingController accountNameController = TextEditingController();
    receiverNameController.text = data.accountName!;
    bankIdController.text = data.accountNumber!;
    accountNameController.text = data.phone!;
    dropBankName = data.bankName!;

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
          receiverNameFocusNode.addListener(() {
            if (receiverNameFocusNode.hasFocus) {
              setState(() {});
            } else {
              setState(() {});
            }
          });
          bankIdFocus.addListener(() {
            if (bankIdFocus.hasFocus) {
              setState(() {});
            } else {
              setState(() {});
            }
          });
          receiverPhoneFocus.addListener(() {
            if (receiverPhoneFocus.hasFocus) {
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
                    FormBuilder(
                      key: fbkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextField(
                            inputType: TextInputType.text,
                            controller: receiverNameController,
                            labelText: 'Хүлээн авагчийн овог, нэр',
                            name: 'receiver',
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
                                return validateName(value.toString());
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
                                      '${data.code}',
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
                            name: 'dansNumber',
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
                            controller: accountNameController,
                            labelText: 'Харилцах утас',
                            name: 'idNumber',
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
                                return validatePhone(value.toString());
                              }
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    CustomButton(
                      onClick: () async {
                        if (fbkey.currentState!.saveAndValidate()) {
                          Receiver info = Receiver();
                          if (receiverNameController.text != "" &&
                              dropBankName != null &&
                              bankIdController.text != "" &&
                              accountNameController.text != "") {
                            info.accountName = receiverNameController.text;
                            info.bankName = dropBankName;
                            info.accountNumber = bankIdController.text;
                            info.phone = accountNameController.text;
                            var res =
                                await UserApi().updateReceiver(info, data.id!);
                            await list(page, limit);
                            print(res);
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      buttonColor: blue,
                      isLoading: false,
                      labelText: 'Болсон',
                      textColor: white,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          border: Border.all(width: 1, color: delete),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading == false
                              ? () async {
                                  var res =
                                      await UserApi().deleteReceiver(data.id!);
                                  await list(page, limit);
                                  Navigator.of(context).pop();
                                  print(res);
                                }
                              : () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading == true)
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 15,
                                  ),
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: delete,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              Text(
                                'Устгах',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: delete,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.transparent,
                            backgroundColor: white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  editTransReceiver(BuildContext context, Receiver data) {
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

    bankNameController.text = data.bankName!;
    accountNumberController.text = data.accountNumber!;
    swiftCodeController.text = data.swiftCode!;
    branchNameController.text = data.branchName!;
    branchAddressController.text = data.branchAddress!;
    accountNameController.text = data.accountName!;

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
            bankName.addListener(() {
              if (bankName.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            accountNumber.addListener(() {
              if (accountNumber.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            swiftCode.addListener(() {
              if (swiftCode.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            branchName.addListener(() {
              if (branchName.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            branchAddress.addListener(() {
              if (branchAddress.hasFocus) {
                setState(() {});
              } else {
                setState(() {});
              }
            });
            accountName.addListener(() {
              if (accountName.hasFocus) {
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
                      SizedBox(height: 24),
                      CustomButton(
                        onClick: () async {
                          if (fbkey.currentState!.saveAndValidate()) {
                            Receiver info = Receiver();
                            if (bankNameController.text != "" &&
                                accountNumberController.text != "" &&
                                swiftCodeController.text != "" &&
                                branchNameController.text != "" &&
                                branchAddressController.text != "" &&
                                accountNameController.text != "") {
                              info.bankName = bankNameController.text;
                              info.accountNumber = accountNumberController.text;
                              info.swiftCode = swiftCodeController.text;
                              info.branchName = branchNameController.text;
                              info.branchAddress = branchAddressController.text;
                              info.accountName = accountNameController.text;
                              var res = await UserApi()
                                  .updateReceiver(info, data.id!);
                              print(res);
                              await list(page, limit);
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        buttonColor: blue,
                        isLoading: false,
                        labelText: 'Болсон',
                        textColor: white,
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: white,
                            border: Border.all(width: 1, color: delete),
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading == false
                                ? () async {
                                    var res = await UserApi()
                                        .deleteReceiver(data.id!);
                                    await list(page, limit);
                                    Navigator.of(context).pop();
                                    print(res);
                                  }
                                : () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isLoading == true)
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 15,
                                    ),
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: delete,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                Text(
                                  'Устгах',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: delete,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.transparent,
                              backgroundColor: white,
                            ),
                          ),
                        ),
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

String? validateNumber(String value) {
  if (value.isEmpty) {
    return "Талбарыг заавал бөглөнө үү";
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Зөвхөн тоо оруулна уу";
  }
  return null;
}
