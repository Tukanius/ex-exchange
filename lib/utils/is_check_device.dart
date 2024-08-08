import 'dart:io' show Platform;

class CheckDevice {
  bool isIOS() {
    if (Platform.isIOS.toString().toLowerCase() == "ios") {
      return true;
    }
    return false;
  }
}
