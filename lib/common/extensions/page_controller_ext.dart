import 'package:flutter/material.dart';

extension PageControllerExt on PageController {
  static int _selectedIndex = 0;

  int get selectedBottomAppBarItemIndex {
    final newIndex = page ?? _selectedIndex;
    if (newIndex > 1) {
      return (newIndex + 1).toInt();
    }
    return newIndex.toInt();
  }

  set setBottomAppBarItemIndex(int newIndex) {
    _selectedIndex = newIndex;
  }
}
