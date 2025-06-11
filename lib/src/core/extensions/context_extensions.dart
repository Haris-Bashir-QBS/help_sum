import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).colorScheme.primaryContainer;
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
