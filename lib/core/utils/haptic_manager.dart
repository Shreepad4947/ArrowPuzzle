import 'package:flutter/services.dart';

class HapticManager {
  HapticManager._();

  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }

  static void errorVibration() {
    HapticFeedback.heavyImpact();
  }

  static void successVibration() {
    HapticFeedback.mediumImpact();
  }
}