import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wx_exchange_flutter/provider/user_provider.dart';
import 'package:wx_exchange_flutter/services/dialog.dart';
import 'package:wx_exchange_flutter/services/navigation.dart';
import 'package:wx_exchange_flutter/services/notify_service.dart';
import 'package:wx_exchange_flutter/src/splash_page/splash_page.dart';
import 'http_handler.dart';
import '../main.dart';

class HttpRequest {
  // static const host = "http://dev-cb-admin.zto.mn";
  static const host = 'https://dev-vx-admin.zto.mn';

  static const version = '/app';
  // static const version = '/api/mobile';

  static const uri = host;

  // static const part = "/mobile";

  Dio dio = Dio();

  Future<dynamic> request(String api, String method, dynamic data,
      {bool handler = true, bool approve = false}) async {
    Response? response;
    final String uri;
    var token = await UserProvider.getAccessToken();

    uri = '$host$version$api';
    debugPrint(uri);

    debugPrint('+++++++++++++++++++++++++++++++++++++++++++++++++++');
    debugPrint('handler: ' + handler.toString());
    debugPrint('+++++++++++++++++++++++++++++++++++++++++++++++++++ ');

    try {
      Directory dir = await getTemporaryDirectory();
      CookieJar cookieJar =
          PersistCookieJar(storage: FileStorage(dir.path), ignoreExpires: true);

      dio.interceptors.add(CookieManager(cookieJar));

      var token = await UserProvider.getAccessToken();
      var deviceToken = "";
      // debugPrint('++++++++++++++++++++++deviceToken+++++++++++++++ ');
      // debugPrint(deviceToken);
      // debugPrint('+++++++++++++++++++++++deviceToken++++++++++++++ ');

      dio.options.headers = {
        'authorization': 'Bearer $token',
        'device-token': '$deviceToken',
        'device_type': 'MOS',
        'device_imei': 'test-imei',
        'device_info': 'iphone 13'
      };
    } catch (err) {
      debugPrint(err.toString());
    }

    if (method != 'GET') {
      debugPrint('body: $data');
    }

    try {
      switch (method) {
        case 'GET':
          {
            response = await dio.get(
              uri,
              queryParameters: data,
            );
            break;
          }
        case 'POST':
          {
            response = await dio.post(uri, data: data);
            break;
          }
        case 'PUT':
          {
            response = await dio.put(uri, data: data);
            break;
          }
        case 'DELETE':
          {
            response = await dio.delete(uri, data: data);
            break;
          }
      }

      return HttpHandler(statusCode: response?.statusCode).handle(response);
    } on DioException catch (ex) {
      // try {
      //   result = await _connectivity.checkConnectivity();
      //   if (result == ConnectivityResult.none) {
      //     MyApp.dialogService!
      //         .showInternetErrorDialog("No internet connection");
      //     return null;
      //   }
      // } on PlatformException catch (e) {
      //   debugPrint(e.toString());
      // }

      if (token != null && ex.response?.statusCode == 401) {
        print('====TOKEN from Green score====');
        print(token);
        print('====TOKEN from Green score====');

        MyApp.setInvalidToken(MyApp.invalidTokenCount + 1);
        if (MyApp.invalidTokenCount == 1) {
          await UserProvider().auth();
          locator<NavigationService>()
              .pushNamed(routeName: SplashScreen.routeName);
          NotifyService().showNotification(
            title: 'WX Exchange',
            body: 'Нэвтрэх эрх хүчингүй боллоо',
          );

          MyApp.setInvalidToken(0);

          return null;
        }
        return;
      }
      HttpHandler? error =
          HttpHandler(statusCode: ex.response?.statusCode).handle(ex.response);

      if (handler == true && error!.message != null) {
        final DialogService dialogService = locator<DialogService>();
        dialogService.showErrorDialog(error.message.toString());
      }

      throw error!;
    }
  }

  Future<dynamic> get(String url, {dynamic data, bool handler = true}) async {
    try {
      return await request(url, 'GET', data, handler: handler);
    } catch (e) {
      debugPrint("GET =>" + e.toString());
      rethrow;
    }
  }

  Future<dynamic> post(String url,
      {dynamic data, bool handler = true, bool approve = false}) async {
    try {
      return await request(
        url,
        'POST',
        data,
        handler: handler,
        approve: approve,
      );
    } catch (e) {
      debugPrint("POST =>" + e.toString());
      rethrow;
    }
  }

  Future<dynamic> put(String url, {dynamic data, bool handler = true}) async {
    try {
      return await request(url, 'PUT', data, handler: handler);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> del(String url, {dynamic data, bool handler = true}) async {
    return await request(url, 'DELETE', data, handler: handler);
  }
}
