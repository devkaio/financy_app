import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/features/sign_in/sign_in_controller.dart';
import 'package:financy_app/features/sign_in/sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockSecureStorage mockSecureStorage;
  late MockFirebaseAuthService mockFirebaseAuthService;
  late SignInController signInController;
  late MockGraphQLService mockGraphQLService;
  late UserModel user;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockFirebaseAuthService = MockFirebaseAuthService();
    mockGraphQLService = MockGraphQLService();
    signInController = SignInController(
      authService: mockFirebaseAuthService,
      secureStorage: mockSecureStorage,
      graphQLService: mockGraphQLService,
    );
    user = UserModel(
      name: 'User',
      email: 'user@email.com',
      id: '1a2b3c4d5e',
    );
  });

  group('Tests Sign In Controller State', () {
    test('Should update state to SignInStateSuccess', () async {
      expect(signInController.state, isInstanceOf<SignInStateInitial>());

      when(() => mockGraphQLService.init()).thenAnswer((_) async => {});

      when(() => mockSecureStorage.write(
            key: "CURRENT_USER",
            value: user.toJson(),
          )).thenAnswer((_) async {});

      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer(
        (_) async => user,
      );

      await signInController.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );
      expect(signInController.state, isInstanceOf<SignInStateSuccess>());
    });

    test('Should update state to SignInStateError', () async {
      expect(signInController.state, isInstanceOf<SignInStateInitial>());

      when(
        () => mockSecureStorage.write(
          key: "CURRENT_USER",
          value: user.toJson(),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenThrow(
        Exception(),
      );

      await signInController.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );
      expect(signInController.state, isInstanceOf<SignInStateError>());
    });
  });
}
