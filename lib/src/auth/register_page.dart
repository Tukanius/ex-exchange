import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
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
                    children: [
                      AnimatedTextField(
                        borderColor: borderBlackColor,
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
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: borderBlackColor,
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
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: borderBlackColor,
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
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1, color: borderColor),
                        ),
                        child: FormBuilderField(
                          autovalidateMode: AutovalidateMode.disabled,
                          name: "registerNo",
                          // validator: FormBuilderValidators.compose([
                          //   FormBuilderValidators.required(
                          //       errorText: 'Заавал бөглөнө үү'),
                          //   (dynamic value) => value.toString() != ""
                          //       ? (validateStructure(letters.join(), value.toString())
                          //           ? null
                          //           : "Регистрийн дугаараа оруулна уу!")
                          //       : null,
                          // ]),
                          builder: (FormFieldState<dynamic> field) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                errorText: field.errorText,
                                fillColor: white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 15,
                                ),
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
                      ),
                      // AnimatedTextField(
                      //   borderColor: borderBlackColor,
                      //   colortext: blackAccent,
                      //   name: 'registerNo',
                      //   focusNode: register,
                      //   labelText: 'Регистрийн дугаар',
                      //   controller: registerController,
                      //   suffixIcon: register.hasFocus == true
                      //       ? GestureDetector(
                      //           onTap: () {
                      //             registerController.clear();
                      //           },
                      //           child: Icon(
                      //             Icons.close_rounded,
                      //             color: black,
                      //           ),
                      //         )
                      //       : null,
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      AnimatedTextField(
                        borderColor: borderBlackColor,
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
                      ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: borderColor),
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(12),
                      //     ),
                      //   ),
                      //   child: DropdownButtonFormField(
                      //       icon: Column(
                      //         children: [
                      //           const Icon(
                      //             Icons.keyboard_arrow_down_rounded,
                      //             color: black,
                      //           ),
                      //         ],
                      //       ),
                      //       onChanged: (value) {
                      //         setState(() {});
                      //       },
                      //       dropdownColor: white,
                      //       elevation: 2,
                      //       focusColor: blue,
                      //       decoration: InputDecoration(
                      //         labelText: 'Иргэншил',
                      //         labelStyle: TextStyle(color: hintText),
                      //         // filled: true,

                      //         border: InputBorder.none,
                      //         contentPadding: EdgeInsets.symmetric(
                      //           horizontal: 16,
                      //           vertical: 6.5,
                      //         ),
                      //       ),
                      //       items: [
                      //         DropdownMenuItem(
                      //           value: 1,
                      //           child: Text(
                      //             'Монгол',
                      //             style: TextStyle(
                      //               color: dark,
                      //               fontSize: 14,
                      //             ),
                      //           ),
                      //         ),
                      //         DropdownMenuItem(
                      //           value: 2,
                      //           child: Text(
                      //             'Япон',
                      //             style: TextStyle(
                      //               color: dark,
                      //               fontSize: 14,
                      //             ),
                      //           ),
                      //         ),
                      //       ]),
                      // ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
