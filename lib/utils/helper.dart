import 'package:flutter/material.dart';

class Helper {
  static void onTapOutside(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
