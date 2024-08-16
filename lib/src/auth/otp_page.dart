import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/back_arrow/back_arrow.dart';
import 'package:wx_exchange_flutter/components/controller/listen.dart';
// import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/password_page.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class OtpPageArguments {
  String username;
  String method;
  OtpPageArguments({
    required this.username,
    required this.method,
  });
}

class OtpPage extends StatefulWidget {
  final String username;
  final String method;
  static const routeName = "OtpPage";
  const OtpPage({
    super.key,
    required this.username,
    required this.method,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with AfterLayoutMixin {
  ListenController listenController = ListenController();
  User user = User();
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  bool isLoading = true;
  bool isSubmit = false;
  bool isGetCode = false;
  int _counter = 10;
  late Timer _timer;
  TextEditingController pinput = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: 20,
      color: black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  @override
  void initState() {
    listenController.addListener(() async {
      await Provider.of<UserProvider>(context, listen: false)
          .getOtp(widget.method, widget.username.toLowerCase().trim());
    });
    super.initState();
  }

  checkOpt(value) async {
    try {
      user.otpCode = value;
      user.otpMethod = widget.method;
      await Provider.of<UserProvider>(context, listen: false).otpVerify(user);
      await Navigator.of(context).pushNamed(PassWordPage.routeName,
          arguments: PassWordPageArguments(method: widget.method));
    } catch (e) {
      pinput.clear();
      print(e.toString());
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    _startTimer();

    try {
      user = await Provider.of<UserProvider>(context, listen: false)
          .getOtp(widget.method, widget.username.toLowerCase().trim());

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  void _startTimer() async {
    if (isSubmit == true) {
      setState(() {
        isGetCode = false;
      });
      _counter = 10;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_counter > 0) {
          setState(() {
            _counter--;
          });
        } else {
          setState(() {
            isGetCode = true;
          });
          _timer.cancel();
        }
      });
    } else {
      setState(() {
        isGetCode = false;
      });
      _counter = 180;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_counter > 0) {
          setState(() {
            _counter--;
          });
        } else {
          setState(() {
            isGetCode = true;
          });
          _timer.cancel();
        }
      });
    }
  }

  String intToTimeLeft(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    String minutes = m.toString().padLeft(2, '0');
    String seconds = s.toString().padLeft(2, '0');
    String result = "$minutes:$seconds";
    return result;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Row(
          children: [
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ArrowBack(),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Баталгаажуулах',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: blue,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset(
                    'assets/svg/wx.svg',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'OTP Баталгаажуулах',
                    style: TextStyle(
                      color: dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46),
                    child: Text(
                      '${user.message!}',
                      style: TextStyle(
                        color: dark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    closeKeyboardWhenCompleted: true,
                    onCompleted: (value) => checkOpt(value),
                    controller: pinput,
                    // onCompleted: (value) => checkOpt(value),
                    // validator: (value) {
                    //   return value == "${user.otpCode}"
                    //       ? null
                    //       : "Буруу байна";
                    // },
                    length: 6,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    defaultPinTheme: defaultPinTheme,
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (isGetCode == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Дахин код авах ',
                          style: TextStyle(
                            color: blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${intToTimeLeft(_counter)} ',
                          style: TextStyle(
                            color: blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'секунд',
                          style: TextStyle(
                            color: blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSubmit = true;
                            });
                            _startTimer();
                            user = await Provider.of<UserProvider>(context,
                                    listen: false)
                                .getOtp(
                              widget.method,
                              widget.username.toLowerCase().trim(),
                            );
                          },
                          child: Text(
                            "Дахин илгээх",
                            style: TextStyle(
                              color: blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: 24,
                  ),
                  // CustomButton(
                  //   onClick: () {
                  //     print('helo');
                  //   },
                  //   buttonColor: blue,
                  //   isLoading: false,
                  //   labelText: 'Баталгаажуулах',
                  // )
                ],
              ),
            ),
    );
  }
}
