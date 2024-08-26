import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/main.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/src/auth/login_page.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ProfileDeletePage extends StatefulWidget {
  static const routeName = "ProfileDeletePage";
  const ProfileDeletePage({super.key});

  @override
  State<ProfileDeletePage> createState() => _ProfileDeletePageState();
}

class _ProfileDeletePageState extends State<ProfileDeletePage> {
  FocusNode password = FocusNode();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool isVisible = true;

  @override
  void initState() {
    password.addListener(() {
      if (password.hasFocus) {
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
            .deleteAccount(save);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushNamed(LoginPage.routeName);
        showSuccess(context);
      } catch (e) {
        locator<DialogService>().showErrorDialogListener(
          "Нууц үг буруу байна.",
        );
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    }
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
                      'Бүртгэл амжилттай устгагдлаа.',
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
          'Бүртгэл устгах',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: grayAccent,
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: borderColor,
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  'Хэрэглэгч та бүртгэлээ устгасан тохиолдолд таны үүсгэсэн бүх хүсэлтүүд болон гүйлгээний түүхийн мэдээлэл устахыг анхаарна уу!',
                  style: TextStyle(
                    color: dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FormBuilder(
                key: fbkey,
                child: AnimatedTextField(
                  obscureText: isVisible,
                  labelText: 'Нууц үг',
                  name: 'password',
                  focusNode: password,
                  borderColor: blue,
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
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onClick: () {
                        Navigator.of(context).pop();
                      },
                      height: 40,
                      buttonColor: blue.withOpacity(0.1),
                      isLoading: false,
                      labelText: 'Болих',
                      textColor: blue,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomButton(
                      onClick: () {
                        onSubmit();
                      },
                      height: 40,
                      buttonColor: delete,
                      isLoading: isLoading,
                      labelText: 'Устгах',
                      textColor: white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
