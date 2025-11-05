import 'package:flutter/material.dart';

class AppRouterObserver extends NavigatorObserver {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void _setLoading({required int delayMs}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
      Future.delayed(Duration(milliseconds: delayMs), () {
        if (isLoading.value) {
          isLoading.value = false;
        }
      });
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _setLoading(delayMs: 600);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _setLoading(delayMs: 400);
    super.didPop(route, previousRoute);
  }
}
