import 'package:financy_app/common/constants/constants.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/sign_up/sign_up_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

class OnbordingRobot {
  const OnbordingRobot();

  Future<void> call(WidgetTester tester) async {
    final splashPage = find.byType(SplashPage);
    await tester.pump();
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.pumpAndSettle();
    expect(onboardingPage, findsOneWidget);

    final getStartedButton = find.byKey(Keys.onboardingGetStartedButton);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    final signUpPage = find.byType(SignUpPage);
    expect(signUpPage, findsOneWidget);

    final signUpListView = find.byKey(Keys.signUpListView);

    final alreadyHaveAccountButton =
        find.byKey(Keys.signUpAlreadyHaveAccountButton);

    await const Utils().dragUntilVisible(
      tester,
      target: alreadyHaveAccountButton,
      scrollable: signUpListView,
    );

    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);

    await tester.pumpAndSettle();

    final signInPage = find.byType(SignInPage);
    expect(signInPage, findsOneWidget);
  }
}
