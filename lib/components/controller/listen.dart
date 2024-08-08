import 'package:flutter/cupertino.dart';

class ListenController extends ChangeNotifier {
  String? value;
  String? listValue;

  ListenController();

  changeVariable(String value) {
    this.value = value;
    notifyListeners();
  }

  refreshList(String value) {
    this.listValue = value;
    notifyListeners();
  }
}
