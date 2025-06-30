import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static errorToast({required BuildContext context, required String message}) {
    CherryToast.error(
      title: Text(message, style: TextStyle(color: Colors.black)),
    ).show(context);
  }

  static successToast({
    required BuildContext context,
    required String message,
  }) {
    CherryToast.success(
      title: Text(message, style: TextStyle(color: Colors.black)),
    ).show(context);
  }

  static infoToast({required BuildContext context, required String message}) {
    CherryToast.success(
      title: Text(message, style: TextStyle(color: Colors.black)),
    ).show(context);
  }

  static warningToast({
    required BuildContext context,
    required String message,
  }) {
    CherryToast.success(
      title: Text(message, style: TextStyle(color: Colors.black)),
    ).show(context);
  }
}
