import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:wx_exchange_flutter/components/back_arrow/back_arrow.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/src/auth/otp_page.dart';
import 'package:wx_exchange_flutter/utils/is_device_size.dart';
import 'package:wx_exchange_flutter/widget/register-number/letter.dart';
import 'package:wx_exchange_flutter/widget/register-number/letters.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';
import 'package:wx_exchange_flutter/widget/ui/form_textfield_reg.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "RegisterPage";
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController registerController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode phone = FocusNode();
  FocusNode firstname = FocusNode();
  FocusNode lastname = FocusNode();
  FocusNode register = FocusNode();
  FocusNode email = FocusNode();
  bool isLoading = false;
  TextEditingController regnumController = TextEditingController();
  List<String> letters = [
    CYRILLIC_ALPHABETS_LIST[0],
    CYRILLIC_ALPHABETS_LIST[0]
  ];
  String registerNo = "";

  @override
  void initState() {
    phone.addListener(() {
      if (phone.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    email.addListener(() {
      if (email.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    firstname.addListener(() {
      if (firstname.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    lastname.addListener(() {
      if (lastname.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    register.addListener(() {
      if (register.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  void onChangeLetter(String item, index) {
    Navigator.pop(context);
    setState(() {
      letters[index] = item;
    });
  }

  onSubmit() async {
    if (fbkey.currentState!.saveAndValidate()) {
      try {
        setState(() {
          isLoading = true;
        });
        User save = User.fromJson(fbkey.currentState!.value);
        // save.registerNo =
        //     '${letters.join()}${fbkey.currentState?.value["registerNo"]}';
        save.registerNo =
            '${letters.join()}${fbkey.currentState?.value["registerNo"]}';
        await Provider.of<UserProvider>(context, listen: false).register(save);
        setState(() {
          isLoading = false;
        });
        await Navigator.of(context).pushNamed(
          OtpPage.routeName,
          arguments:
              OtpPageArguments(method: "REGISTER", username: save.phone!),
        );
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            'Бүртгүүлэх',
            style: TextStyle(
              color: dark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                  'Бүртгүүлэх',
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
                        borderColor: blue,
                        colortext: blackAccent,
                        name: 'firstName',
                        focusNode: firstname,
                        labelText: 'Овог',
                        controller: firstnameController,
                        suffixIcon: firstname.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  firstnameController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     errorFirstName = isValidCryllic(value);
                        //   });
                        // },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return isValidCryllic(value.toString());
                          }
                        ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: blue,
                        colortext: blackAccent,
                        name: 'lastName',
                        focusNode: lastname,
                        labelText: 'Нэр',
                        controller: lastnameController,
                        suffixIcon: lastname.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  lastnameController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     errorLastName = isValidCryllic(value);
                        //   });
                        // },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return isValidCryllic(value.toString());
                          }
                        ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: blue,
                        colortext: blackAccent,
                        name: 'phone',
                        focusNode: phone,
                        labelText: 'Утасны дугаар',
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     errorPhone = validatePhone(value);
                        //   });
                        // },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return validatePhone(value.toString());
                          }
                        ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FormBuilderField(
                        autovalidateMode: AutovalidateMode.disabled,
                        name: "registerNo",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Заавал бөглөнө үү',
                          ),
                          (dynamic value) {
                            String stringValue = value.toString().trim();

                            if (!RegExp(r'^\d{8}$').hasMatch(stringValue)) {
                              return 'Регистрийн дугаар 8 цифр байх ёстой!';
                            }

                            return null; // Valid input
                          },
                        ]),
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              errorText: field.errorText,
                              fillColor: white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: blue,
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: cancel,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: blue,
                                  width: 1,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: blue,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: blue,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 15,
                              ),
                              labelText: 'Регистрийн дугаар',
                            ),
                            child: Container(
                              child: Row(
                                children: [
                                  RegisterLetters(
                                    width: DeviceSize.width(3, context),
                                    height: DeviceSize.height(90, context),
                                    oneTitle: "Регистер дугаар сонгох",
                                    hideOnPressed: false,
                                    title: letters[0],
                                    textColor: dark,
                                    length: CYRILLIC_ALPHABETS_LIST.length,
                                    itemBuilder: (ctx, i) => RegisterLetter(
                                      text: CYRILLIC_ALPHABETS_LIST[i],
                                      onPressed: () {
                                        onChangeLetter(
                                            CYRILLIC_ALPHABETS_LIST[i], 0);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RegisterLetters(
                                    width: DeviceSize.width(3, context),
                                    height: DeviceSize.height(90, context),
                                    title: letters[1],
                                    oneTitle: "Регистер дугаар сонгох",
                                    hideOnPressed: false,
                                    textColor: dark,
                                    length: CYRILLIC_ALPHABETS_LIST.length,
                                    itemBuilder: (ctx, i) => RegisterLetter(
                                      text: CYRILLIC_ALPHABETS_LIST[i],
                                      onPressed: () {
                                        onChangeLetter(
                                            CYRILLIC_ALPHABETS_LIST[i], 1);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: FormTextField(
                                      maxLenght: 8,
                                      showCounter: false,
                                      inputType: TextInputType.number,
                                      colortext: dark,
                                      color: transparent,
                                      onChanged: (value) {
                                        setState(() {
                                          registerNo = value!;
                                        });
                                        // ignore: invalid_use_of_protected_member
                                        field.setValue(value);
                                      },
                                      controller: regnumController,
                                      name: 'registerNumber',
                                      hintText: 'Регистрийн дугаар',
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: blue,
                        colortext: blackAccent,
                        name: 'email',
                        focusNode: email,
                        labelText: 'И-мэйл',
                        controller: emailController,
                        suffixIcon: email.hasFocus == true
                            ? GestureDetector(
                                onTap: () {
                                  emailController.clear();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: black,
                                ),
                              )
                            : null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     errorEmail = validateEmail(value);
                        //   });
                        // },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return validateEmail(value.toString());
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
                  isLoading: isLoading,
                  labelText: 'Бүртгүүлэх',
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool validateStructure(String value, String number) {
  if (number.length <= 8) return false;
  if (isNumeric(number)) {
    return true;
  }
  return true;
}

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }

  return !int.parse(s).isNaN;
}

String? isValidCryllic(String name) {
  String pattern = r'(^[а-яА-ЯӨөҮүЁёӨө -]+$)';
  RegExp isValidName = RegExp(pattern);
  if (name.isEmpty) {
    return "Заавар оруулна";
  } else {
    if (!isValidName.hasMatch(name)) {
      return "Зөвхөн крилл үсэг ашиглана";
    } else {
      return null;
    }
  }
}

String? validatePhone(String value) {
  RegExp regex = RegExp(r'^[689][0-9]{7}$');
  if (value.isEmpty) {
    return 'Заавар оруулна';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Утасны дугаараа шалгана уу';
    } else {
      return null;
    }
  }
}

String? validateReg(String value) {
  if (value.isEmpty) {
    return 'Заавал оруулна уу';
  }

  if (!RegExp(r'^\d{8}$').hasMatch(value)) {
    return '8 оронтой тоо оруулна уу!';
  }

  return null;
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'И-Мэйлээ оруулна уу';
  } else {
    return null;
  }
}
