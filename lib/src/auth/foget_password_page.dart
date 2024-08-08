import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/back_arrow/back_arrow.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/otp_page.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ForgetPasswordPage extends StatefulWidget {
  static const routeName = "ForgetPasswordPage";
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  TextEditingController phoneController = TextEditingController();
  FocusNode phone = FocusNode();
  bool isLoading = false;
  @override
  void initState() {
    phone.addListener(() {
      if (phone.hasFocus) {
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
            .forgetPass(save);
        setState(() {
          isLoading = false;
        });

        await Navigator.of(context).pushNamed(OtpPage.routeName,
            arguments:
                OtpPageArguments(method: "FORGOT", username: save.username!));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    }
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
              'Нууц үг сэргээх',
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
                    borderColor: borderBlackColor,
                    colortext: blackAccent,
                    name: 'username',
                    focusNode: phone,
                    labelText: 'Утасны дугаар эсвэл имэйл',
                    controller: phoneController,
                    suffixIcon: phone.hasFocus == true
                        ? GestureDetector(
                            onTap: () {
                              phoneController.clear();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: black,
                            ),
                          )
                        : null,
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
              isLoading: isLoading,
              labelText: 'Үргэлжлүүлэх',
            )
          ],
        ),
      ),
    );
  }
}
