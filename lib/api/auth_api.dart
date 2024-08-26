import 'package:wx_exchange_flutter/models/user.dart';
import 'package:wx_exchange_flutter/utils/http_request.dart';

class AuthApi extends HttpRequest {
  login(User data) async {
    var res = await post('/auth/login', data: data.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  me(bool handler) async {
    var res = await get('/auth/me', handler: handler);
    return User.fromJson(res as Map<String, dynamic>);
  }

  forgetPass(User user) async {
    var res = await post('/auth/forgot', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  getPhoneOtp(String otpMethod, String username) async {
    var res = await get(
      "/otp?otpMethod=$otpMethod&username=$username",
    );
    return User.fromJson(res as Map<String, dynamic>);
  }

  otpVerify(User data) async {
    Map<String, dynamic> json = {};
    json['otpCode'] = data.otpCode;
    json['otpMethod'] = data.otpMethod;
    var res = await post('/otp/verify', data: json, handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  setPassword(User user) async {
    var res =
        await post('/auth/change-password', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  updatePassword(User user) async {
    var res =
        await put('/user/change-password', data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }

  logout() async {
    var res = await post('/auth/logout', handler: false);
    return res;
  }

  register(User user) async {
    var res = await post("/auth/register", data: user.toJson(), handler: true);
    return User.fromJson(res as Map<String, dynamic>);
  }
}
