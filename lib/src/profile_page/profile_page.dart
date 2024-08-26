import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/api/auth_api.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/components/custom_button/profile_info_button.dart';
import 'package:wx_exchange_flutter/components/loader/loader.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/login_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/profile_detail_page.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/address_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/email_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/password_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/phone_settings.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/profile_delete.dart';
import 'package:wx_exchange_flutter/src/profile_page/settings/receiver_settings.dart';
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
  bool danStatus = false;
  @override
  afterFirstLayout(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      user = await AuthApi().me(false);
      user.userStatus == "NEW"
          ? setState(() {
              danStatus = false;
            })
          : setState(() {
              danStatus = true;
            });
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

  upDateDanStatus(bool status) {
    setState(() {
      danStatus = status;
    });
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
                          upDateDanStatus(true);
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

  showError() {
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
                      'Дан баталгаажуулалт хийгдсэн байна. Дахин баталгаажуулах боломжгүй.',
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

  bool danLoading = false;

  void onLogOut(BuildContext context) async {
    bool? shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Баталгаажуулах",
            style: TextStyle(
              color: dark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            "Та гарахдаа итгэлтэй байна уу?",
            style: TextStyle(
              color: dark,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Болих",
                style: TextStyle(color: blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                "Гарах",
                style: TextStyle(color: blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (shouldLogOut == true) {
      await Provider.of<UserProvider>(context, listen: false).logout();
      Navigator.of(context).pushNamed(LoginPage.routeName);
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ProfileDetailPage.routeName,
                                arguments:
                                    ProfileDetailPageArguments(data: user));
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName}',
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
                            ),
                          ),
                        ),
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
                    danVerify: danStatus,
                    onClick: () {
                      if (user.userStatus == "NEW") {
                        danVerify(context);
                      } else {
                        showError();
                      }
                    },
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
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(ReceiverSettingsPage.routeName);
                    },
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
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       border: Border.all(color: borderColor, width: 1),
                  //       color: white,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             SvgPicture.asset(
                  //               'assets/svg/mini_face_id.svg',
                  //             ),
                  //             SizedBox(
                  //               width: 12,
                  //             ),
                  //             Text(
                  //               'FaceID-р нэвтрэх',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 12,
                  //                 color: dark,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         CupertinoSwitch(
                  //           value: face,
                  //           onChanged: (bool value) {
                  //             setState(() {
                  //               face = value;
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 16,
                  // ),
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
                  ProfileInfoButton(
                    text: 'Бүртгэлээ устгах',
                    svgPath: 'assets/svg/delete.svg',
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(ProfileDeletePage.routeName);
                    },
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     padding: EdgeInsets.all(16),
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       border: Border.all(color: borderColor, width: 1),
                  //       color: white,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             SvgPicture.asset('assets/svg/delete.svg'),
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   'Бүртгэлээ устгах',
                  //                   style: TextStyle(
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 12,
                  //                     color: dark,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //         Icon(
                  //           Icons.arrow_forward_ios_outlined,
                  //           color: dark,
                  //           size: 14,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      onLogOut(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: blue, width: 1),
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
