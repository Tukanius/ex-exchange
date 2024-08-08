import 'dart:async';
import 'package:flutter/material.dart';

class DialogService {
  late Function getContextListener;
  late Function(String) showSuccessDialogListener;
  late Function() showSuccessDialogListener2;
  late Function() customDialogListener;
  late Function(String) showErrorDialogListener;
  late Function(String)? showNotification;
  late Function(ListTile p1, {int? duration}) showNotificationListener;
  Completer? dialogCompleter;

  BuildContext? getContext() {
    return getContextListener();
  }

  void registerGetContextListener(Function getContextListener) {
    getContextListener = getContextListener;
  }

  void registerSuccessDialogListener(Function(String p1) showDialogListener) {
    showSuccessDialogListener = showDialogListener;
  }

  void registerErrorDialogListener(Function(String p1) showDialogListener) {
    showErrorDialogListener = showDialogListener;
  }

  void registerNotification(
      Function(ListTile p1, {int? duration}) showNotificationListener) {
    this.showNotificationListener = showNotificationListener;
  }

  Future showSuccessDialog(alert) {
    dialogCompleter = Completer();
    showSuccessDialogListener2();

    return dialogCompleter!.future;
  }

  Future customDialog(alert) {
    dialogCompleter = Completer();
    customDialogListener();

    return dialogCompleter!.future;
  }

  bool errorAlert = true;
  showInternetErrorDialog(String message) async {
    if (errorAlert == true) {
      errorAlert = false;
      dialogCompleter = Completer();
      showErrorDialogListener(message);
    }

    await Future.delayed(const Duration(milliseconds: 500), () {
      errorAlert = true;
    });

    return null;
  }

  Future? showErrorDialog(String message) {
    dialogCompleter = Completer();
    showErrorDialogListener(message);

    return dialogCompleter?.future;
  }

  Future? showNotificarion(ListTile message, {int? duration}) {
    dialogCompleter = Completer();
    showNotificationListener(message, duration: duration);

    return dialogCompleter?.future;
  }

  void dialogComplete() {
    dialogCompleter?.complete();
    dialogCompleter = null;
  }
}
