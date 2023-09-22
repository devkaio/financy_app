import 'package:financy_app/common/data/exceptions.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/services/user_data_service/user_data_service.dart';
import 'package:financy_app/services/user_data_service/user_data_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late UserDataService sut;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFunctions mockFirebaseFunctions;
  late FakeUser fakeUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFunctions = MockFirebaseFunctions();
    fakeUser = FakeUser();
    sut = UserDataServiceImpl(
      firebaseAuth: mockFirebaseAuth,
      firebaseFunctions: mockFirebaseFunctions,
    );
  });

  group('Tests UserDataService', () {
    test(
        'When getUserData is called and user is not null, returns sucess with user model data',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(fakeUser);

      final result = await sut.getUserData();

      result.fold(
        (error) => null,
        (data) {
          expect(data, isA<UserModel>());
          expect(data.email, 'user@email.com');
          expect(data.id, '123456abc');
          expect(data.name, 'User');
        },
      );
    });

    test(
        'When getUserData is called and user is null, returns failure with exception',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await sut.getUserData();

      result.fold(
        (error) {
          expect(error, isA<Failure>());
          expect(error, isA<UserDataException>());
          expect(error.message, 'User data not found. Please login again.');
        },
        (data) => null,
      );
    });

    test(
        'When getUserData is called and firebase throws exception, returns failure with exception',
        () async {
      when(() => mockFirebaseAuth.currentUser)
          .thenThrow(const UserDataException(code: 'not-found'));

      final result = await sut.getUserData();

      result.fold(
        (error) {
          expect(error, isA<Failure>());
          expect(error, isA<UserDataException>());
          expect(error.message, 'User data not found. Please login again.');
        },
        (data) => null,
      );
    });

    test(
        'When deleteAccount is called and the account is deleted, returns success with value true',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(fakeUser);
      when(() => mockFirebaseAuth.currentUser?.delete())
          .thenAnswer((_) async {});

      final result = await sut.deleteAccount();

      result.fold(
        (error) => null,
        (data) {
          expect(data, isA<bool>());
          expect(data, true);
        },
      );
    });

    test(
        'When deleteAccount is called and the account is not deleted, returns failure with exception',
        () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(fakeUser);
      when(() => mockFirebaseAuth.currentUser?.delete())
          .thenThrow(const UserDataException(code: 'delete-account'));

      final result = await sut.deleteAccount();

      result.fold(
        (error) {
          expect(error, isA<Failure>());
          expect(error, isA<UserDataException>());
          expect(error.message,
              'An error has occurred while deleting user account. Please try again later.');
        },
        (data) => null,
      );
    });
  });
}
