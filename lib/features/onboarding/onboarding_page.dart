// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:financy_app/common/constants/app_colors.dart';
import 'package:financy_app/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iceWhite,
      body: Align(
        child: Column(
          children: [
            const SizedBox(height: 48.0),
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/images/man.png',
              ),
            ),
            Text(
              'Spend Smarter',
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.greelightTwo,
              ),
            ),
            Text(
              'Save More',
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.greelightTwo,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: PrimaryButton(
                text: 'Get Started',
                onPressed: () {},
              ),
            ),
            Text(
              'Already have account? Log In',
              style: AppTextStyles.smallText.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
