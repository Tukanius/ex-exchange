import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToUntil(route) {
    return navigatorKey.currentState!
        .pushAndRemoveUntil(route, (predicate) => false);
  }

  Future<dynamic> navigateTo(route) {
    return navigatorKey.currentState!.pushNamed(route);
  }

  Future<dynamic> pushNamed({required String routeName, arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed({required String routeName, arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> restorablePopAndPushNamed(
      {required String routeName, arguments}) async {
    return navigatorKey.currentState!
        .restorablePopAndPushNamed(routeName, arguments: arguments);
  }

  dynamic pop() {
    return navigatorKey.currentState!.pop();
  }
}
