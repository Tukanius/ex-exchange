import 'package:flutter/cupertino.dart';
// import 'package:green_score/main.dart';
// import 'package:green_score/services/dialog.dart';

class HttpHandler {
  int? statusCode;
  String? message;
  String? code;
  // static bool _isNavigating = false;
  HttpHandler({this.statusCode, this.message, this.code});

  String? parseMessage(dynamic data) {
    if (data.runtimeType == <String, dynamic>{}.runtimeType) {
      Map<String, dynamic> json = data as Map<String, dynamic>;
      return json['message'] as String?;
    } else {
      return data as String;
    }
  }

  handle(dynamic response) {
    debugPrint(
        '+++++++++++++++++++++++++API HANDLER++++++++++++++++++++++++++');
    debugPrint('HttpHandler: ' +
        response.toString() +
        ", " +
        statusCode.toString() +
        ' dataType:${response?.data?.runtimeType.toString()}');
    debugPrint(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    dynamic data = <String, dynamic>{};

    if (response?.data?.runtimeType.toString() != "".runtimeType.toString()) {
      data = response.data;
    }

    switch (statusCode) {
      case 200:
      case 304:
        return data;
      case 401:
        // locator<DialogService>().showErrorDialogListener("Нэвтэрнэ үү");
        // Navigator.of(context).pushNamed(SplashScreen.routeName);
        // navigatorKey.currentState?.pushNamed('SplashScreen');
        // break;
        // if (!_isNavigating) {
        //   _isNavigating = true;
        //   // locator<DialogService>().showErrorDialogListener("Нэвтэрнэ үү");
        //   navigatorKey.currentState?.pushNamed('SplashScreen').then((_) {
        //     _isNavigating = false;
        //   });
        // }
        break;
      default:
        HttpHandler error = HttpHandler(
            statusCode: statusCode,
            code: data['code'] as String?,
            message: data['message'] as String?);

        return error;
    }
  }
}
