import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/widget/dialog/dialog_wrapper.dart';

class SuccessDialog {
  final BuildContext? context;
  final DialogService? dialogService;
  final Duration duration = const Duration(milliseconds: 1500);

  SuccessDialog({this.context, this.dialogService});

  void show(String message) {
    showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (context) {
        // Future.delayed(duration, () {
        //   dialogService!.dialogComplete();

        //   // ignore: unnecessary_null_comparison
        //   if (context == null) return;
        //   if (Navigator.of(context, rootNavigator: true).canPop()) {
        //     Navigator.of(context).pop(true);
        //   }
        // });

        return DialogWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Center(
                child: Icon(
                  Icons.check_circle,
                  size: 65.0,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        );
      },
    );
  }
}
