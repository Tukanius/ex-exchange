import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class PhoneSettingsPageArguments {
  String phone;
  PhoneSettingsPageArguments({
    required this.phone,
  });
}

class PhoneSettingsPage extends StatefulWidget {
  final String phone;
  static const routeName = "PhoneSettingsPage";
  const PhoneSettingsPage({super.key, required this.phone});

  @override
  State<PhoneSettingsPage> createState() => _PhoneSettingsPageState();
}

class _PhoneSettingsPageState extends State<PhoneSettingsPage> {
  FocusNode phone = FocusNode();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    phone.addListener(() {
      if (phone.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    phoneController.text = widget.phone;
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
          'Утасны дугаар',
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
              labelText: 'Утасны дугаар',
              name: 'phone',
              focusNode: phone,
              borderColor: blue,
              colortext: dark,
              controller: phoneController,
              suffixIcon: phone.hasFocus == true
                  ? GestureDetector(
                      onTap: () {
                        phoneController.clear();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: dark,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
