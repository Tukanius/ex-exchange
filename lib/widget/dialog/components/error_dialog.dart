import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/widget/ui/color.dart';

class ErrorDialog {
  final BuildContext? context;
  final DialogService? dialogService;
  final Duration duration = const Duration(seconds: 30);

  ErrorDialog({
    this.context,
    this.dialogService,
  });

  void show(String message, {VoidCallback? onPress}) {
    final currentContext = context;
    showDialog(
      context: currentContext!,
      barrierDismissible: true,
      builder: (context) {
        // Future.delayed(duration, () {
        //   dialogService!.dialogComplete();
        //   if (Navigator.of(context, rootNavigator: true).canPop()) {
        //     Navigator.of(context).pop(true);
        //   }
        // });
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
                      message,
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
                            "Ойлголоо",
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
