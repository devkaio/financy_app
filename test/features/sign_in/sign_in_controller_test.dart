import 'package:financy_app/common/data/data_result.dart';
import 'package:financy_app/common/data/exceptions.dart';
import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/features/sign_in/sign_in_controller.dart';
import 'package:financy_app/features/sign_in/sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  //Mocking dependencies to test SUT
  late MockSecureStorageService mockSecureStorage;
  late MockFirebaseAuthService mockFirebaseAuthService;
  late MockSyncService mockSyncService;

  //Subject Under Test
  late SignInController sut;

  late UserModel user;

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    mockFirebaseAuthService = MockFirebaseAuthService();
    mockSyncService = MockSyncService();

    sut = SignInController(
      authService: mockFirebaseAuthService,
      secureStorageService: mockSecureStorage,
    );

    user = UserModel(
      name: 'User',
      email: 'user@email.com',
      id: '1a2b3c4d5e',
    );

    when(() => mockSyncService.syncFromServer())
        .thenAnswer((_) async => DataResult.success(null));

    when(() => mockSecureStorage.write(
          key: "CURRENT_USER",
          value: user.toJson(),
        )).thenAnswer((_) async {});
  });

  group('Tests Sign In Controller State', () {
    test('Should update state to SignInStateSuccess', () async {
      expect(sut.state, isInstanceOf<SignInStateInitial>());

      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer(
        (_) async => DataResult.success(user),
      );

      await sut.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );

      expect(sut.state, isInstanceOf<SignInStateLoading>());
    });

    test('Should update state to SignInStateError', () async {
      expect(sut.state, isInstanceOf<SignInStateInitial>());

      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer((_) async => DataResult.failure(const GeneralException()));

      await sut.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );

      expect(sut.state, isInstanceOf<SignInStateError>());
    });
  });
}
