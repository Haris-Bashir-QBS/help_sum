import 'package:flutter/material.dart';

class UnFocusOnNavigateObserver extends NavigatorObserver {
  void _unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _unFocus();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _unFocus();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _unFocus();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
