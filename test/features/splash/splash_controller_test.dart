import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/features/splash/splash_controller.dart';
import 'package:financy_app/features/splash/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockSyncService mockSyncService;
  late MockSecureStorageService mockSecureStorage;
  late SplashController splashController;
  late UserModel user;

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    mockSyncService = MockSyncService();
    splashController = SplashController(
      secureStorageService: mockSecureStorage,
    );
    user = UserModel(
      name: 'User',
      email: 'user@email.com',
      id: '1a2b3c4d5e',
    );

    when(() => mockSyncService.syncFromServer())
        .thenAnswer((_) async => DataResult.success(null));
    when(() => mockSyncService.syncToServer())
        .thenAnswer((_) async => DataResult.success(null));
  });

  group('Tests Splash Controller', () {
    test('Should update state to UnauthenticatedUser', () async {
      when(() => mockSecureStorage.readOne(key: 'CURRENT_USER'))
          .thenAnswer((_) async => null);

      expect(splashController.state, isInstanceOf<SplashStateInitial>());

      await splashController.isUserLogged();

      expect(splashController.state, isInstanceOf<UnauthenticatedUser>());
    });
    test('Should update state to AuthenticatedUser', () async {
      when(() => mockSecureStorage.readOne(key: 'CURRENT_USER'))
          .thenAnswer((_) async => user.toJson());

      expect(splashController.state, isInstanceOf<SplashStateInitial>());

      await splashController.isUserLogged();

      expect(splashController.state, isInstanceOf<AuthenticatedUser>());
    });
  });
}
