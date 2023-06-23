import 'package:financy_app/app.dart' as financy_app;
import 'package:financy_app/common/widgets/widgets.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/sign_up/sign_up_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:financy_app/firebase_options.dart';
import 'package:financy_app/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Onboarding Test', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    setupDependencies();

    await locator.allReady();

    await tester.pumpWidget(const financy_app.App());

    final splashPage = find.byType(SplashPage);
    await tester.pump();
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.pumpAndSettle();
    expect(onboardingPage, findsOneWidget);

    final getStartedButton = find.byType(PrimaryButton);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    final signUpPage = find.byType(SignUpPage);
    await tester.pumpAndSettle();
    expect(signUpPage, findsOneWidget);

    final alreadyHaveAccountButton = find.byType(MultiTextButton);
    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);
    await tester.pumpAndSettle();

    final signInPage = find.byType(SignInPage);
    await tester.pumpAndSettle();
    expect(signInPage, findsOneWidget);
  });
}
