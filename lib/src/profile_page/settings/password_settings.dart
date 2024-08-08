import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class PasswordSettingsPage extends StatefulWidget {
  static const routeName = "PasswordSettingsPage";
  const PasswordSettingsPage({super.key});

  @override
  State<PasswordSettingsPage> createState() => _PasswordSettingsPageState();
}

class _PasswordSettingsPageState extends State<PasswordSettingsPage> {
  FocusNode password = FocusNode();
  FocusNode passwordNew = FocusNode();
  FocusNode passwordRepeat = FocusNode();

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  bool isVisible = true;
  bool isVisible1 = true;
  bool isVisible2 = true;

  @override
  void initState() {
    password.addListener(() {
      if (password.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    passwordNew.addListener(() {
      if (passwordNew.hasFocus) {
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
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark,
          ),
        ),
        title: Text(
          'Нэвтрэх нууц үг',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.check,
                  color: dark,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedTextField(
              obscureText: isVisible,
              labelText: 'Хуучин нууц үг',
              name: 'password',
              focusNode: password,
              borderColor: borderBlackColor,
              colortext: dark,
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
                              : Icon(Icons.visibility_off, color: iconColor),
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
                            color: dark,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    )
                  : null,
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              obscureText: isVisible1,
              labelText: 'Шинэ нууц үг',
              name: 'passwordNew',
              focusNode: passwordNew,
              borderColor: borderBlackColor,
              colortext: dark,
              controller: passwordNewController,
              suffixIcon: passwordNew.hasFocus == true
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
                              : Icon(Icons.visibility_off, color: iconColor),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            passwordNewController.clear();
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: dark,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    )
                  : null,
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextField(
              obscureText: isVisible2,
              labelText: 'Нууц үг баталгаажуулах',
              name: 'passwordRepeat',
              focusNode: passwordRepeat,
              borderColor: borderBlackColor,
              colortext: dark,
              controller: passwordRepeatController,
              suffixIcon: passwordRepeat.hasFocus == true
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible2 = !isVisible2;
                            });
                          },
                          icon: isVisible2 == false
                              ? Icon(Icons.visibility, color: iconColor)
                              : Icon(Icons.visibility_off, color: iconColor),
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
                            color: dark,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    )
                  : null,
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
