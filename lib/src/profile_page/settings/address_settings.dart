import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/widget/ui/animated_text_field/animated_textfield.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class AddressSettingsPage extends StatefulWidget {
  static const routeName = "AddressSettingsPage";
  const AddressSettingsPage({super.key});

  @override
  State<AddressSettingsPage> createState() => _AddressSettingsPageState();
}

class _AddressSettingsPageState extends State<AddressSettingsPage> {
  FocusNode address = FocusNode();
  TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    address.addListener(() {
      if (address.hasFocus) {
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
          'Гэрийн хаяг',
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
              labelText: 'Гэрийн хаяг',
              name: 'address',
              focusNode: address,
              borderColor: borderBlackColor,
              colortext: dark,
              controller: addressController,
              suffixIcon: address.hasFocus == true
                  ? GestureDetector(
                      onTap: () {
                        addressController.clear();
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
