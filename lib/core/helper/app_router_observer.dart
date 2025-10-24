import 'package:flutter/material.dart';

class AppRouterObserver extends NavigatorObserver {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void didPush(Route route, Route? previousRoute) {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
    super.didPop(route, previousRoute);
  }
}
