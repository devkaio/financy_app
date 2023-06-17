import 'package:financy_app/common/data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock_classes.dart';

void main() {
  late MockFirebaseAuthService mockFirebaseAuthService;
  late MockUser user;
  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
    user = MockUser();
  });

  group(
    'Tests Firebase Auth Service - Sign Up',
    () {
      test('Should return created user', () async {
        when(
          () => mockFirebaseAuthService.signUp(
            name: 'User',
            email: 'user@email.com',
            password: 'user@123',
          ),
        ).thenAnswer(
          (_) async => DataResult.success(user),
        );

        final result = await mockFirebaseAuthService.signUp(
          name: 'User',
          email: 'user@email.com',
          password: 'user@123',
        );

        expect(
          result.data,
          user,
        );
      });

      test('Should throw exception', () async {
        when(
          () => mockFirebaseAuthService.signUp(
            name: 'User',
            email: 'user@email.com',
            password: 'user@123',
          ),
        ).thenThrow(
          Exception(),
        );

        expect(
          () => mockFirebaseAuthService.signUp(
            name: 'User',
            email: 'user@email.com',
            password: 'user@123',
          ),
          // throwsA(isInstanceOf<Exception>()),
          throwsException,
        );
      });
    },
  );

  group('Tests Firebase Auth Service - Sign In', () {
    test('Should return user data', () async {
      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer(
        (_) async => DataResult.success(user),
      );

      final result = await mockFirebaseAuthService.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );

      expect(
        result.data,
        user,
      );
    });

    test('Should throw exception', () async {
      when(
        () => mockFirebaseAuthService.signIn(
          email: 'user@email.com',
          password: 'user@123',
        ),
      ).thenAnswer((_) async => DataResult.failure(const GeneralException()));

      final result = await mockFirebaseAuthService.signIn(
        email: 'user@email.com',
        password: 'user@123',
      );

      result.fold(
        (error) => expect(error, isA<Exception>()),
        (data) => expect(data, null),
      );
    });
  });
}
