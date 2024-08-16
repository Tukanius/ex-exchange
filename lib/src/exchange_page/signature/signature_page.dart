import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:wx_exchange_flutter/components/custom_button/custom_button.dart';
import 'package:wx_exchange_flutter/src/exchange_page/exchange_order/order_info_page.dart';
import 'package:wx_exchange_flutter/src/transfer_page/remittance/remittance.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';
import 'package:signature/signature.dart';

class SignaturePageArguments {
  String pushedFrom;
  SignaturePageArguments({
    required this.pushedFrom,
  });
}

class SignaturePage extends StatefulWidget {
  final String pushedFrom;
  static const routeName = "SignaturePage";
  const SignaturePage({super.key, required this.pushedFrom});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> with AfterLayoutMixin {
  Uint8List? exportedImage;

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: black,
  );
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    print(widget.pushedFrom);
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
          'Таны гарын үсэг',
          style: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: white,
      extendBody: true,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Signature(
                controller: controller,
                backgroundColor: white,
                width: MediaQuery.of(context).size.width,
                height: 300,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onClick: () {
                      controller.clear();
                    },
                    buttonColor: blue.withOpacity(0.1),
                    isLoading: false,
                    labelText: 'Дахин зурах',
                    textColor: blue,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomButton(
                    onClick: () async {
                      exportedImage = await controller.toPngBytes();
                      setState(() {});
                      exportedImage != null
                          ? widget.pushedFrom == 'EXCHANGE'
                              ? Navigator.of(context).pushNamed(
                                  OrderInfoPage.routeName,
                                  arguments: OrderInfoPageArguments(
                                    signature: exportedImage!,
                                  ),
                                )
                              : Navigator.of(context).pushNamed(
                                  RemittancePage.routeName,
                                  arguments: RemittancePageArguments(
                                    signature: exportedImage!,
                                  ),
                                )
                          : showErrorReceiver();
                    },
                    buttonColor: blue,
                    isLoading: false,
                    labelText: 'Үргэлжлүүлэх',
                    textColor: white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // if (exportedImage != null)
          ],
        ),
      ),
    );
  }

  showErrorReceiver() {
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
                      'Гарын үсгээ оруулна уу.',
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
}
