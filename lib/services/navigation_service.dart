import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static replaceTo(String routeName) {
    navigatorKey.currentState!.pushReplacementNamed(routeName);
  }
}
