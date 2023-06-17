import 'package:financy_app/common/data/data_result.dart';
import 'package:financy_app/common/data/exceptions.dart';
import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/features/sign_up/sign_up_controller.dart';
import 'package:financy_app/features/sign_up/sign_up_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockSecureStorageService mockSecureStorage;
  late MockFirebaseAuthService mockFirebaseAuthService;

  late SignUpController sut;

  late UserModel user;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
    mockSecureStorage = MockSecureStorageService();

    sut = SignUpController(
      authService: mockFirebaseAuthService,
      secureStorageService: mockSecureStorage,
    );

    user = UserModel(
      name: 'User',
      email: 'user@email.com',
      id: '1a2b3c4d5e',
    );

    when(() => mockSecureStorage.write(
          key: "CURRENT_USER",
          value: user.toJson(),
        )).thenAnswer((_) async {});
  });

  group('Tests Sign Up Controller State', () {
    test('Should update state to SignUpStateSuccess', () async {
      expect(sut.state, isInstanceOf<SignUpStateInitial>());

      when(
        () => mockFirebaseAuthService.signUp(
          name: 'User',
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer(
        (_) async => DataResult.success(user),
      );

      when(() => mockSecureStorage.write(
            key: "CURRENT_USER",
            value: user.toJson(),
          )).thenAnswer((_) async {});

      await sut.signUp(
        name: 'User',
        email: 'user@email.com',
        password: 'user@123',
      );

      expect(sut.state, isInstanceOf<SignUpStateLoading>());

      await Future.delayed(Duration.zero);

      expect(sut.state, isInstanceOf<SignUpStateSuccess>());
    });

    test('Should update state to SignUpStateError', () async {
      expect(sut.state, isInstanceOf<SignUpStateInitial>());

      when(
        () => mockFirebaseAuthService.signUp(
          name: 'User',
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer((_) async => DataResult.failure(const GeneralException()));

      await sut.signUp(
        name: 'User',
        email: 'user@email.com',
        password: 'user@123',
      );

      expect(sut.state, isInstanceOf<SignUpStateError>());
    });
  });
}
