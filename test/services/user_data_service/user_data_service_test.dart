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
  late FakeUser fakeUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeUser = FakeUser();
    sut = UserDataServiceImpl(firebaseAuth: mockFirebaseAuth);
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
      when(() => mockFirebaseAuth.currentUser).thenThrow(Exception());

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
  });
}
