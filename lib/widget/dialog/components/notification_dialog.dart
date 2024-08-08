import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';

class NotificationDialog {
  final BuildContext? context;
  final DialogService? dialogService;

  NotificationDialog({this.context, this.dialogService});

  void show(ListTile listTile, {int? duration}) {
    Flushbar(
      duration: Duration(milliseconds: duration ?? 3000),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      // borderColor: Colors.grey,
      borderRadius: BorderRadius.circular(2.0),
      onTap: (flushbar) {
        flushbar.dismiss();
      },
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 2,
          offset: const Offset(0, 0.2),
        ),
      ],
      messageText: listTile,
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.all(0.0),
      animationDuration: const Duration(milliseconds: 500),
    ).show(context!);
  }
}
