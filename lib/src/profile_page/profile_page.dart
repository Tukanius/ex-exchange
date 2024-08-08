import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/api/auth_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/profile_info_button.dart';
import 'package:wx_exchange_flutter/components/loader/loader.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/address_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/email_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/password_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/phone_settings.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "ProfilePage";
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AfterLayoutMixin {
  bool face = false;
  User user = User();
  bool isLoading = false;
  @override
  afterFirstLayout(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      user = await AuthApi().me(false);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Center(
              child: SvgPicture.asset('assets/svg/back_arrow.svg'),
            ),
          ),
        ),
        title: Text(
          'Тохиргоо',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: greytext,
                        child: SvgPicture.asset('assets/svg/avatar.svg'),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.lastName}',
                            style: TextStyle(
                              color: dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${user.email}',
                            style: TextStyle(
                              color: gray,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ProfileInfoButton(
                    text: 'ДАН баталгаажуулалт',
                    svgPath: 'assets/svg/button_profile.svg',
                    dan: true,
                    onClick: () {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ProfileInfoButton(
                    text: 'Утасны дугаар',
                    svgPath: 'assets/svg/phone.svg',
                    onClick: () {
                      Navigator.of(context).pushNamed(
                        PhoneSettingsPage.routeName,
                        arguments:
                            PhoneSettingsPageArguments(phone: user.phone!),
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ProfileInfoButton(
                    text: 'И-Мэйл',
                    svgPath: 'assets/svg/at.svg',
                    onClick: () {
                      Navigator.of(context).pushNamed(
                        EmailSettingsPage.routeName,
                        arguments:
                            EmailSettingsPageArguments(email: user.email!),
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ProfileInfoButton(
                    text: 'Гэрийн хаяг',
                    svgPath: 'assets/svg/home.svg',
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(AddressSettingsPage.routeName);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ProfileInfoButton(
                    text: 'Хүлээн авагчийн жагсаалт',
                    svgPath: 'assets/svg/receivers.svg',
                    onClick: () {},
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Аюулгүй байдал',
                    style: TextStyle(
                      color: dark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                        color: white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/mini_face_id.svg',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                'FaceID-р нэвтрэх',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: dark,
                                ),
                              ),
                            ],
                          ),
                          CupertinoSwitch(
                            value: face,
                            onChanged: (bool value) {
                              setState(() {
                                face = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ProfileInfoButton(
                    text: 'Нэвтрэх нууц үг',
                    svgPath: 'assets/svg/profile_key.svg',
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(PasswordSettingsPage.routeName);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                        color: white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Бүртгэлээ устгах',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: dark,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: dark,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Provider.of<UserProvider>(context, listen: false)
                          .logout();
                      Navigator.of(context).pushNamed(SplashScreen.routeName);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                        color: white,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Гарах',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Хувилбар 1.0.3',
                        style: TextStyle(
                          color: dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '© 2024 Developed by Goodtech Soft',
                        style: TextStyle(
                          color: dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          if (isLoading == true) CustomLoader()
        ],
      ),
    );
  }
}
