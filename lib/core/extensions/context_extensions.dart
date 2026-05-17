import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<T?> showAppDialog<T>(Widget dialog) {
    return showDialog<T>(
      context: this,
      barrierDismissible: false,
      builder: (_) => dialog,
    );
  }

  void pushScreen(Widget screen) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void pushReplacementScreen(Widget screen) {
    Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void pushAndRemoveAll(Widget screen) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }

  void popScreen() {
    Navigator.of(this).pop();
  }
}