import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/back_arrow/back_arrow.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/login_page.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class PassWordPageArguments {
  String? method;
  PassWordPageArguments({
    this.method,
  });
}

class PassWordPage extends StatefulWidget {
  final String? method;
  static const routeName = "PassWordPage";
  const PassWordPage({super.key, this.method});

  @override
  State<PassWordPage> createState() => _PassWordPageState();
}

class _PassWordPageState extends State<PassWordPage> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();

  FocusNode password = FocusNode();
  FocusNode passwordRepeat = FocusNode();

  bool isLoading = false;

  bool isVisible = true;
  bool isVisible1 = true;
  @override
  void initState() {
    password.addListener(() {
      if (password.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    passwordRepeat.addListener(() {
      if (passwordRepeat.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  onSubmit() async {
    if (fbkey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isLoading = true;
        });

        User save = User.fromJson(fbkey.currentState!.value);
        await Provider.of<UserProvider>(context, listen: false)
            .setPassword(save);

        setState(() {
          isLoading = false;
        });
        await Navigator.of(context).pushNamed(SplashScreen.routeName);
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // showSuccess(ctx) async {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         alignment: Alignment.center,
  //         margin: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Stack(
  //           alignment: Alignment.topCenter,
  //           children: <Widget>[
  //             Container(
  //               margin: const EdgeInsets.only(top: 75),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   const Text(
  //                     'Амжилттай',
  //                     style: TextStyle(
  //                         color: dark,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 24),
  //                   ),
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                   const Text(
  //                     'Нууц үг амжилттай үүслээ.',
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   ButtonBar(
  //                     buttonMinWidth: 100,
  //                     alignment: MainAxisAlignment.spaceEvenly,
  //                     children: <Widget>[
  //                       TextButton(
  //                         style: ButtonStyle(
  //                           overlayColor:
  //                               MaterialStateProperty.all(Colors.transparent),
  //                         ),
  //                         child: const Text(
  //                           "хаах",
  //                           style: TextStyle(color: dark),
  //                         ),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Lottie.asset('assets/lottie/success.json',
  //                 height: 150, repeat: false),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
                Navigator.of(context).pushNamed(LoginPage.routeName);
              },
              child: ArrowBack(),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Нууц үг',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
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
              'Шинэ нууц үг үүсгэх',
              style: TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            FormBuilder(
              key: fbkey,
              child: Column(
                children: [
                  AnimatedTextField(
                    obscureText: isVisible,
                    borderColor: blue,
                    colortext: blackAccent,
                    name: 'password',
                    focusNode: password,
                    labelText: 'Нууц үг',
                    controller: passwordController,
                    suffixIcon: password.hasFocus == true
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: isVisible == false
                                    ? Icon(Icons.visibility, color: iconColor)
                                    : Icon(Icons.visibility_off,
                                        color: iconColor),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  passwordController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          )
                        : null,
                    validator: FormBuilderValidators.compose([
                      (value) {
                        return validatePassword(value.toString(), context);
                      }
                    ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AnimatedTextField(
                    obscureText: isVisible1,
                    borderColor: blue,
                    colortext: blackAccent,
                    name: 'password1',
                    focusNode: passwordRepeat,
                    labelText: 'Нууц үг давтан хийх',
                    controller: passwordRepeatController,
                    suffixIcon: passwordRepeat.hasFocus == true
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible1 = !isVisible1;
                                  });
                                },
                                icon: isVisible1 == false
                                    ? Icon(Icons.visibility, color: iconColor)
                                    : Icon(Icons.visibility_off,
                                        color: iconColor),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  passwordRepeatController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          )
                        : null,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Нууц үгээ давтан оруулна уу"),
                      (value) {
                        if (fbkey.currentState?.fields['password']?.value !=
                            value) {
                          return 'Оруулсан нууц үгтэй таарахгүй байна';
                        }
                        return null;
                      }
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            CustomButton(
              onClick: () {
                onSubmit();
              },
              buttonColor: blue,
              isLoading: false,
              labelText: 'Болсон',
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

String? validatePassword(String value, context) {
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Нууц үг багадаа 1 том үсэг 1 тоо авна';
    } else {
      return null;
    }
  }
}
