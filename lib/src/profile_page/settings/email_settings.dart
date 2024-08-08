import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class EmailSettingsPageArguments {
  String email;
  EmailSettingsPageArguments({
    required this.email,
  });
}

class EmailSettingsPage extends StatefulWidget {
  final String email;
  static const routeName = "EmailSettingsPage";
  const EmailSettingsPage({super.key, required this.email});

  @override
  State<EmailSettingsPage> createState() => _EmailSettingsPageState();
}

class _EmailSettingsPageState extends State<EmailSettingsPage> {
  FocusNode email = FocusNode();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    email.addListener(() {
      if (email.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    emailController.text = widget.email;
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
          'И-Мэйл',
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
              labelText: 'И-Мейл',
              name: 'email',
              focusNode: email,
              borderColor: borderBlackColor,
              colortext: dark,
              controller: emailController,
              suffixIcon: email.hasFocus == true
                  ? GestureDetector(
                      onTap: () {
                        emailController.clear();
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
