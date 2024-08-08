// ignore: unused_import
import 'dart:io' show Platform;
import '../utils/is_check_device.dart';
import 'package:flutter/material.dart';

class DeviceSize {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height * (p / 100);
  }

  static double heightSize(double p, BuildContext context) {
    var height = DeviceSize.height(p, context);
    return height;
  }

  static isiPhoneX(BuildContext context) {
    var src = height(100, context);
    var srcWidth = width(100, context);
    return (CheckDevice().isIOS() &&
        ((src.height == 812 || srcWidth.width == 812) ||
            (src.height == 896 || srcWidth.width == 896)));
  }

  static bool isSmallDevice(BuildContext context) {
    bool isSmallDevice = false;

    var srcHeight = height(100, context);

    if (srcHeight <= 700) {
      return isSmallDevice = true;
    } else {
      return isSmallDevice;
    }
  }
}
