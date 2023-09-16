import 'package:financy_app/common/data/data_result.dart';
import 'package:financy_app/common/data/exceptions.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/features/profile/profile_controller.dart';
import 'package:financy_app/features/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late ProfileController sut;
  late MockUserDataService userDataService;
  setUp(() {
    userDataService = MockUserDataService();
    sut = ProfileController(userDataService: userDataService);
  });

  group('Tests ProfileController State', () {
    test('Initial state should be ProfileInitialState', () {
      expect(sut.state, isA<ProfileStateInitial>());
    });

    test(
        'When getUserData is called and return success, state should be ProfileStateSuccess',
        () async {
      when(() => userDataService.getUserData()).thenAnswer(
        (_) async => DataResult.success(
          UserModel(
            email: 'user@email.com',
            name: 'User',
            id: '123',
          ),
        ),
      );

      await sut.getUserData();

      expect(sut.state, isA<ProfileStateSuccess>());
      expect((sut.state as ProfileStateSuccess).user, isA<UserModel>());
      expect((sut.state as ProfileStateSuccess).user?.email, 'user@email.com');
      expect((sut.state as ProfileStateSuccess).user?.name, 'User');
      expect((sut.state as ProfileStateSuccess).user?.id, '123');
    });

    test(
        'When getUserData is called and return failure, state should be ProfileStateFailure',
        () async {
      when(() => userDataService.getUserData()).thenAnswer(
        (_) async =>
            DataResult.failure(const UserDataException(code: 'not-found')),
      );

      await sut.getUserData();

      expect(sut.state, isA<ProfileStateError>());
      expect((sut.state as ProfileStateError).message,
          'User data not found. Please login again.');
    });

    test(
        'When deleteAccount is called and return success, state should be ProfileStateSuccess',
        () async {
      when(() => userDataService.deleteAccount())
          .thenAnswer((_) async => DataResult.success(true));

      await sut.deleteAccount();

      expect(sut.state, isA<ProfileStateSuccess>());
    });

    test(
        'When deleteAccount is called and return failure, state should be ProfileStateFailure',
        () async {
      when(() => userDataService.deleteAccount()).thenAnswer(
        (_) async =>
            DataResult.failure(const UserDataException(code: 'delete-account')),
      );

      await sut.deleteAccount();

      expect(sut.state, isA<ProfileStateError>());
      expect((sut.state as ProfileStateError).message,
          'An error has occurred while deleting user account. Please try again later.');
    });
  });
}
