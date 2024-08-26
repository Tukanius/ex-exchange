import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class PasswordSettingsPage extends StatefulWidget {
  static const routeName = "PasswordSettingsPage";
  const PasswordSettingsPage({super.key});

  @override
  State<PasswordSettingsPage> createState() => _PasswordSettingsPageState();
}

class _PasswordSettingsPageState extends State<PasswordSettingsPage> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
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
                      'Нууц үг амжилттай шинэчлэгдлээ.',
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

  bool isLoading = false;

  onChange() async {
    if (fbkey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isLoading = true;
        });
        User save = User.fromJson(fbkey.currentState!.value);
        await Provider.of<UserProvider>(context, listen: false)
            .updatePassword(save);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        showSuccess(context);
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
      }
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
                onTap: isLoading == true
                    ? () {}
                    : () {
                        onChange();
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
        child: FormBuilder(
          key: fbkey,
          child: Column(
            children: [
              AnimatedTextField(
                obscureText: isVisible,
                labelText: 'Хуучин нууц үг',
                name: 'oldPassword',
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
                validator: FormBuilderValidators.compose([
                  (value) {
                    return validateEmpty(value.toString());
                  }
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              AnimatedTextField(
                obscureText: isVisible1,
                labelText: 'Шинэ нууц үг',
                name: 'password',
                focusNode: passwordNew,
                borderColor: blue,
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
                obscureText: isVisible2,
                labelText: 'Нууц үг баталгаажуулах',
                name: 'passwordRepeat',
                focusNode: passwordRepeat,
                borderColor: blue,
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
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? validatePassword(String value, context) {
  RegExp regex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,12}$");

  if (value.isEmpty) {
    return 'Нууц үгээ оруулна уу!';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Нууц үг багадаа 1 том үсэг 1 тоо 1 тусгай тэмдэгт авна';
    } else {
      return null;
    }
  }
}

String? validateEmpty(String value) {
  if (value.isEmpty) {
    return 'Заавал оруулна уу!';
  } else {
    return null;
  }
}
