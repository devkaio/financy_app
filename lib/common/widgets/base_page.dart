import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(
            30.0,
          ),
          right: Radius.circular(
            30.0,
          ),
        ),
      ),
      child: child,
    );
  }
}
