import 'package:financy_app/common/constants/constants.dart';
import 'package:financy_app/features/forgot_password/check_your_email_page.dart';
import 'package:financy_app/features/onboarding/onboarding.dart';
import 'package:financy_app/features/sign_in/sign_in.dart';
import 'package:financy_app/features/splash/splash.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robot_extension.dart';

class ForgotPasswordRobot {
  const ForgotPasswordRobot(this.tester);

  final WidgetTester tester;

  ///Remember to set [shouldFail] to `true` when login must fail.
  Future<void> forgotPassword(
      {required String email, bool shouldFail = false}) async {
    final splashPage = find.byType(SplashPage);
    await tester.waitUntilFind(splashPage);
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.waitUntilFind(onboardingPage);
    expect(onboardingPage, findsOneWidget);

    final alreadyHaveAccountButton =
        find.byKey(Keys.onboardingAlreadyHaveAccountButton);

    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);

    final signInPage = find.byType(SignInPage);
    await tester.waitUntilFind(signInPage);
    expect(signInPage, findsOneWidget);

    final forgotPasswordButton = find.byKey(Keys.forgotPasswordButton);

    expect(forgotPasswordButton, findsOneWidget);

    await tester.tap(forgotPasswordButton);
    await tester.pumpAndSettle();

    final emailField = find.byKey(Keys.forgotPasswordEmailField);
    await tester.waitUntilFind(emailField);
    expect(emailField, findsOneWidget);

    if (shouldFail) {
      await tester.enterText(emailField, 'wrong@email.com');
    } else {
      await tester.enterText(emailField, email);
    }

    final sendLinkButton = find.byKey(Keys.forgotPasswordSendLinkButton);

    await tester.waitUntilFind(sendLinkButton);

    expect(sendLinkButton, findsOneWidget);
    await tester.tap(sendLinkButton);
    await tester.pumpAndSettle();

    if (shouldFail) {
      final tryAgainText = find.text('Try again');
      expect(tryAgainText, findsOneWidget);
      await tester.tap(tryAgainText);
    } else {
      final checkYourEmailPage = find.byType(CheckYourEmailPage);
      await tester.waitUntilFind(checkYourEmailPage);
      expect(checkYourEmailPage, findsOneWidget);
    }
  }
}
