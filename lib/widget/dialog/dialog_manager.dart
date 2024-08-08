import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/main.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/widget/dialog/components/error_dialog.dart';
import 'package:wx_exchange_flutter/widget/dialog/components/notification_dialog.dart';
import 'package:wx_exchange_flutter/widget/dialog/components/success_dialog.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;
  const DialogManager({super.key, this.child});
  @override
  DialogManagerState createState() => DialogManagerState();
}

class DialogManagerState extends State<DialogManager> {
  DialogService? dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    dialogService!.registerGetContextListener(getContext);
    dialogService!.registerSuccessDialogListener(
        SuccessDialog(context: context, dialogService: dialogService).show);
    dialogService!.registerErrorDialogListener(
        ErrorDialog(context: context, dialogService: dialogService).show);
    dialogService!.registerNotification(
        NotificationDialog(context: context, dialogService: dialogService)
            .show);
  }

  BuildContext getContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
