import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/features/forgot_password/forgot_password_controller.dart';
import 'package:financy_app/features/forgot_password/forgot_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  // Mocking dependencies to test SUT
  late MockFirebaseAuthService mockFirebaseAuthService;

  // Subject Under Test
  late ForgotPasswordController sut;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();

    sut = ForgotPasswordController(
      authService: mockFirebaseAuthService,
    );
  });

  group('Tests Forgot Password Controller State', () {
    test('Should update state to ForgotPasswordStateSuccess', () async {
      expect(sut.state, isInstanceOf<ForgotPasswordStateInitial>());

      when(() => mockFirebaseAuthService.forgotPassword(any())).thenAnswer(
        (_) async => DataResult.success(true),
      );

      await sut.forgotPassword('user@email.com');

      expect(sut.state, isInstanceOf<ForgotPasswordStateSuccess>());
    });
  });

  test('Should update state to ForgotPasswordStateError', () async {
    expect(sut.state, isInstanceOf<ForgotPasswordStateInitial>());

    when(() => mockFirebaseAuthService.forgotPassword(any()))
        .thenAnswer((_) async => DataResult.failure(const GeneralException()));

    await sut.forgotPassword('user@email.com');

    expect(sut.state, isInstanceOf<ForgotPasswordStateError>());
  });
}
