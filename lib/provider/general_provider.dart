import 'package:flutter/material.dart';
import 'package:wx_exchange_flutter/api/general_api.dart';
import 'package:wx_exchange_flutter/models/general.dart';

class GeneralProvider extends ChangeNotifier {
  General general = General();

  init(bool handler) async {
    general = await GeneralApi().init(handler);
    notifyListeners();
  }
}
