import 'package:flutter_test/flutter_test.dart';

import 'forgot_password_robot.dart';
import 'onboarding_robot.dart';
import 'sign_in_robot.dart';
import 'sign_out_robot.dart';

extension RobotExtension on WidgetTester {
  OnboardingRobot get onboarding => OnboardingRobot(this);

  SignInRobot get signInRobot => SignInRobot(this);

  SignOutRobot get signOutRobot => SignOutRobot(this);

  ForgotPasswordRobot get forgotPasswordRobot => ForgotPasswordRobot(this);

  Future<void> waitUntilFind(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    const interval = Duration(milliseconds: 1000);
    while (!any(finder)) {
      await pumpAndSettle();
      timeout -= interval;
      if (timeout.inSeconds == 0) {
        throw TestFailure('Timeout waiting for $finder');
      }
    }
  }

  Future<void> dragUntilFind({
    required Finder target,
    required Finder scrollable,
  }) async {
    await dragUntilVisible(
      target,
      scrollable,
      const Offset(0, -50),
    );
  }
}
