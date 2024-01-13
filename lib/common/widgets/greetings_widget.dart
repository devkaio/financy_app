import 'package:financy_app/features/home/home.dart';
import 'package:financy_app/locator.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../extensions/extensions.dart';

class GreetingsWidget extends StatelessWidget {
  const GreetingsWidget({
    super.key,
  });

  String get _greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 18) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.sizeOf(context).width < 360 ? 0.7 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          textScaler: TextScaler.linear(textScaleFactor),
          style: AppTextStyles.smallText.apply(color: AppColors.white),
        ),
        Text(
          (locator.get<HomeController>().userData.name ?? '')
              .capitalize()
              .firstWord,
          textScaler: TextScaler.linear(textScaleFactor),
          style: AppTextStyles.mediumText20.apply(color: AppColors.white),
        ),
      ],
    );
  }
}
