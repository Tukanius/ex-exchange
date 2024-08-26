import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/provider/general_provider.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/login_page.dart';
import 'package:wx_exchange_flutter/src/main_page.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  int isOne = 2;

  // @override
  // void initState() async {
  //   super.initState();
  //   await Provider.of<UserProvider>(context, listen: false).me(false);
  //   await Provider.of<GeneralProvider>(context, listen: false).init(true);
  // }

  @override
  afterFirstLayout(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).me(false);
      await Provider.of<GeneralProvider>(context, listen: false).init(true);
      Navigator.of(context).pushNamed(
        MainPage.routeName,
        arguments: MainPageArguments(initialIndex: 1),
      );
    } catch (ex) {
      debugPrint(ex.toString());
      Navigator.of(context).pushNamed(LoginPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            )
          ],
        ),
      ),
    );
  }
}
