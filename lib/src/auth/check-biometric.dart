// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:after_layout/after_layout.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'package:wx_exchange_flutter/utils/secure_storage.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class CheckBiometric extends StatefulWidget {
  static const routeName = 'biocheck';

  const CheckBiometric({Key? key}) : super(key: key);

  @override
  _CheckBiometricState createState() => _CheckBiometricState();
}

class _CheckBiometricState extends State<CheckBiometric> with AfterLayoutMixin {
  bool isLoading = false;
  final LocalAuthentication auth = LocalAuthentication();
  final SecureStorage secureStorage = SecureStorage();
  bool bioMetric = false;
  final String fingerPrintIcon = "assets/svg/finger-print.svg";
  final String faceIdIcon = "assets/svg/face-id.svg";
  String bioType = "";

  @override
  afterFirstLayout(BuildContext context) async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      setState(() {
        bioType = "FACE";
      });
    }
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      setState(() {
        bioType = "FINGER_PRINT";
      });
    }
  }

  Future<void> _authenticate() async {
    try {
      setState(() {
        isLoading = true;
      });
      bioMetric = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }

    secureStorage.setBioMetric(bioMetric);

    Navigator.of(context).pushNamed(SplashScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 80),
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: blue,
                ),
                alignment: Alignment.center,
                child: bioType == "FACE"
                    ? SvgPicture.asset(
                        faceIdIcon,
                        color: white,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : SvgPicture.asset(
                        fingerPrintIcon,
                        color: white,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Та тохиргоог идэвхжүүлснээр цаашид апп руу нэвтрэхэд нэвтрэх нэр нууц үг хийх шаардлагагүй.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CustomButton(
              onClick: () {
                _authenticate();
              },
              buttonColor: blue,
              labelText: "Зөвшөөрөх",
              textColor: white,
              isLoading: isLoading,
            ),
            SizedBox(
              height: 8,
            ),
            CustomButton(
              onClick: () {
                Navigator.of(context).pushNamed(SplashScreen.routeName);
              },
              buttonColor: blue.withOpacity(0.1),
              labelText: "Алгасах",
              textColor: blue,
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}
