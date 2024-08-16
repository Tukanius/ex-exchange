// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/main.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/services/notify_service.dart';
import 'package:wx_exchange_flutter/src/auth/check-biometric.dart';
import 'package:wx_exchange_flutter/src/auth/foget_password_page.dart';
import 'package:wx_exchange_flutter/src/auth/register_page.dart';
import 'package:wx_exchange_flutter/src/main_page.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'package:wx_exchange_flutter/utils/secure_storage.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "LoginPage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AfterLayoutMixin {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  bool isVisible = true;
  bool isLoading = false;
  final focusNodeUsername = FocusNode();
  final focusNodePassword = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioContoller = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  final SecureStorage secureStorage = SecureStorage();
  bool isSubmit = false;

  String fingerPrintIcon = "assets/svg/finger-print.svg";
  String faceIdIcon = "assets/svg/face-id.svg";

  bool isBioMetric = false;
  bool activeBio = false;
  String bioType = "";
  bool saveIsUsername = false;
  String? errorUserName;
  String deviceToken = '';
  bool isLoadingPage = false;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    Future<String?> usernameStore = secureStorage.getUserName();
    String resultUsername = await usernameStore ?? "";

    print('=============STORED==========');
    print(resultUsername);
    print('=============STORED==========');
    if (resultUsername != "") {
      setState(() {
        phoneController.text = resultUsername;
        saveIsUsername = true;
      });
    }
    try {
      setState(() {
        isLoadingPage = true;
      });
      initFireBase();
      setState(() {
        isLoadingPage = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPage = false;
      });
      print(e.toString());
    }
  }

  initFireBase() async {
    deviceToken = await getDeviceToken();
    print('====CHECKDEVICETOKEN=====');
    print(deviceToken);
    print('====CHECKDEVICETOKEN=====');
  }

  Future getDeviceToken() async {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _fireBaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _fireBaseMessage.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('ehelsee');
        NotifyService().showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        print('${message.notification?.title}');
        print('${message.notification?.body}');
        print('duusasaa');
      }
    });
    return (deviceToken == null) ? "" : deviceToken;
  }

  onSubmit() async {
    final String username;

    if (fbkey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isLoading = true;
        });
        if (saveIsUsername == true) {
          username = fbkey.currentState?.fields['username']?.value;
          _storePhone(username);
        }

        await initFireBase();
        User save = User.fromJson(fbkey.currentState!.value);
        save.deviceToken = deviceToken;
        await Provider.of<UserProvider>(context, listen: false).login(save);
        UserProvider().setUsername(save.username.toString());
        await Provider.of<UserProvider>(context, listen: false).me(true);
        setState(() {
          isLoading = false;
        });
        // await Navigator.of(context).pushNamed(SplashScreen.routeName);
        await Navigator.of(context).pushNamed(MainPage.routeName,
            arguments: MainPageArguments(initialIndex: 0));
      } catch (e) {
        locator<DialogService>().showErrorDialogListener(
          "Нэвтрэх нэр эсвэл нууц үг буруу байна.",
        );
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    }
  }

  _storePhone(String username) async {
    await secureStorage.setUserName(username);
  }
  // @override
  // FutureOr<void> afterFirstLayout(BuildContext context) async {
  //   Future<String?> futureResult = secureStorage.getBioMetric();
  //   String result = await futureResult ?? "";
  //   if (result == "true") {
  //     setState(() {
  //       isBioMetric = true;
  //     });
  //   }
  //   // ···
  //   final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //   final bool canAuthenticate =
  //       canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  //   setState(() {
  //     activeBio = canAuthenticate;
  //   });
  //   if (activeBio == true && isBioMetric == true) {
  //     String? username = await UserProvider().getUsername();
  //     if (username == null || username == "") {
  //       setState(() {
  //         saveIsUsername = false;
  //       });
  //     } else {
  //       setState(() {
  //         saveIsUsername = true;
  //       });
  //     }
  //     setState(() {
  //       saveIsUsername == true
  //           ? phoneController.text = username!
  //           : saveIsUsername = false;
  //     });
  //   }
  //   if (activeBio == true) {
  //     final List<BiometricType> availableBiometrics =
  //         await auth.getAvailableBiometrics();
  //     if (availableBiometrics.contains(BiometricType.face)) {
  //       setState(() {
  //         bioType = "FACE";
  //       });
  //     } else {}
  //     if (availableBiometrics.contains(BiometricType.fingerprint)) {
  //       setState(() {
  //         bioType = "FINGER_PRINT";
  //       });
  //     }
  //     if (isBioMetric == false) {
  //       String? username = await UserProvider().getUsername();
  //       if (username == null || username == "") {
  //         setState(() {
  //           saveIsUsername = false;
  //         });
  //       } else {
  //         setState(() {
  //           saveIsUsername = true;
  //         });
  //       }
  //       setState(() {
  //         saveIsUsername == true
  //             ? phoneController.text = username!
  //             : saveIsUsername = false;
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    focusNodeUsername.addListener(() {
      if (focusNodeUsername.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    focusNodePassword.addListener(() {
      if (focusNodePassword.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: white,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    SvgPicture.asset(
                      'assets/svg/wx.svg',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Transfer & Exchange',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextField(
                            inputType: TextInputType.text,
                            controller: phoneController,
                            borderColor: blue,
                            colortext: blackAccent,
                            name: 'username',
                            suffixIcon: null,
                            focusNode: focusNodeUsername,
                            onChanged: (value) {
                              secureStorage.deleteAll();
                              setState(() {
                                isBioMetric = false;
                              });
                              setState(() {
                                errorUserName = validateReceiverName(value);
                              });
                            },
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(
                                      'assets/svg/login.svg',
                                      color: focusNodeUsername.hasFocus == true
                                          ? blue
                                          : iconColor,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            labelText: 'И-мэйл',
                            // validator: FormBuilderValidators.compose([
                            //   FormBuilderValidators.required(
                            //       errorText: 'Утасны дугаар оруулна уу.')
                            // ]),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          AnimatedTextField(
                            inputType: TextInputType.text,
                            // onComplete: () {
                            //   _performLogin(context);
                            // },
                            controller: passwordController,
                            borderColor: blue,
                            name: 'password',
                            colortext: blackAccent,
                            obscureText: isVisible,
                            focusNode: focusNodePassword,
                            suffixIcon: IconButton(
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
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(
                                      'assets/svg/key.svg',
                                      color: focusNodePassword.hasFocus == true
                                          ? blue
                                          : iconColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            labelText: 'Нууц үг',
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  saveIsUsername = !saveIsUsername;
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1.5, color: borderColor),
                                ),
                                child: saveIsUsername == true
                                    ? SvgPicture.asset(
                                        'assets/svg/remember.svg')
                                    : null,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Сануулах',
                              style: TextStyle(
                                color: blackAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ForgetPasswordPage.routeName);
                          },
                          child: Text(
                            'Нууц үгээ мартсан ?',
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    //
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            isLoading: isLoading,
                            onClick: () {
                              onSubmit();
                              // _performLogin(context);
                            },
                            buttonColor: blue,
                            textColor: white,
                            labelText: 'Нэвтрэх',
                          ),
                        ),
                        if (isBioMetric == true)
                          Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loginBio();
                                },
                                child:
                                    SvgPicture.asset('assets/svg/face_id1.svg'),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      onClick: () {
                        Navigator.of(context).pushNamed(RegisterPage.routeName);
                      },
                      isLoading: false,
                      buttonColor: blue.withOpacity(0.1),
                      textColor: blue,
                      labelText: 'Бүртгүүлэх',
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     NotifyService().showNotification(
                    //       title: 'Мөнгөн гуйвуулга',
                    //       body: 'Henlov',
                    //     );
                    //   },
                    //   child: Text(
                    //     '123',
                    //   ),
                    // ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _performLogin(BuildContext context) async {
    final String phone;
    final String password;
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (fbkey.currentState!.saveAndValidate()) {
      phone = fbkey.currentState?.fields['username']?.value;
      password = fbkey.currentState?.fields['password']?.value;
      try {
        setState(() {
          isSubmit = true;
        });
        User save = User.fromJson(fbkey.currentState!.value);
        UserProvider().setUsername(save.username.toString());
        await Provider.of<UserProvider>(context, listen: false).login(save);
        await _storeCredentials(phone, password);
        if (activeBio == true && availableBiometrics.isNotEmpty) {
          Navigator.of(context).pushNamed(CheckBiometric.routeName);
        } else {
          Navigator.of(context).pushNamed(SplashScreen.routeName);
        }
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          locator<DialogService>().showErrorDialogListener(
            "Нэвтрэх нэр эсвэл нууц үг буруу байна.",
          );
          isSubmit = false;
        });
      }
    }
  }

  Future<void> loginBio() async {
    bool authenticated = false;
    User save = User();
    try {
      setState(() {
        isSubmit = true;
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated == true) {
        Future<String?> username = secureStorage.getUserName();
        Future<String?> password = secureStorage.getPassWord();
        String resultUsername = await username ?? "";
        String resultPassword = await password ?? "";
        save.username = resultUsername;
        save.password = resultPassword;
        await Provider.of<UserProvider>(context, listen: false).login(save);
        Navigator.of(context).pushNamed(SplashScreen.routeName);
      }
      setState(() {
        isSubmit = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        locator<DialogService>().showErrorDialogListener(
          "Нэвтрэх нэр эсвэл нууц үг буруу байна.",
        );
        isSubmit = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }
  }

  _storeCredentials(String phone, String password) async {
    await secureStorage.setUserName(phone);
    await secureStorage.setPassWord(password);
  }
}

String? validateReceiverName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Нэр оруулна уу';
  }
  return null;
}
