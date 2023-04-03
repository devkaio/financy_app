import 'package:flutter/material.dart';

extension PageControllerExt on PageController {
  static int _selectedIndex = 0;

  int get selectedBottomAppBarItemIndex {
    final newIndex = page ?? 0;
    if (newIndex > 1) {
      return (newIndex + 1).toInt();
    }
    return _selectedIndex;
  }

  set setBottomAppBarItemIndex(int newIndex) {
    _selectedIndex = newIndex;
  }
}
