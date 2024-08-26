import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wx_exchange_flutter/api/auth_api.dart';
import 'package:wx_exchange_flutter/api/user_api.dart';
import 'package:wx_exchange_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  User user = User();
  bool isView = false;
  bool isVerified = false;

  Future<User> login(User data) async {
    data = await AuthApi().login(data);
    setAccessToken(data.accessToken);
    notifyListeners();
    return data;
  }

  me(bool handler) async {
    user = await AuthApi().me(handler);
    setAccessToken(user.accessToken);
    notifyListeners();
  }

  setAccessToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) prefs.setString("ACCESS_TOKEN", token);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("ACCESS_TOKEN");
    return token;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("PHONE");
    return username;
  }

  setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("PHONE", username);
  }

  logout() async {
    user = User();
    clearAccessToken();
    notifyListeners();
  }

  clearAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("ACCESS_TOKEN");
  }

  forgetPass(User data) async {
    user = await AuthApi().forgetPass(data);
    setAccessToken(user.accessToken);
    return user;
  }

  getOtp(String otpMethod, String username) async {
    var res = await AuthApi().getPhoneOtp(otpMethod, username);
    return res;
  }

  otpVerify(User data) async {
    data = await AuthApi().otpVerify(data);
    await setAccessToken(data.accessToken);
    return data;
  }

  setPassword(User data) async {
    user = await AuthApi().setPassword(data);
    setAccessToken(user.accessToken);
    notifyListeners();
    return user;
  }

  updatePassword(User data) async {
    user = await AuthApi().updatePassword(data);
    notifyListeners();
  }

  register(User data) async {
    user = await AuthApi().register(data);
    setAccessToken(user.accessToken);
    return user;
  }

  auth() async {
    String? token = await getAccessToken();
    if (token != null) {
      await clearAccessToken();
    }
  }

  deleteAccount(User data) async {
    var res = await UserApi().accountDelete(data);
    return res;
  }
}
