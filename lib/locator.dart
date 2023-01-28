import 'package:get_it/get_it.dart';

import 'features/home/home_controller.dart';
import 'features/sign_in/sign_in_controller.dart';
import 'features/sign_up/sign_up_controller.dart';
import 'features/splash/splash_controller.dart';
import 'repositories/transaction_repository.dart';
import 'services/auth_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/secure_storage.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(),
  );

  locator.registerFactory<SplashController>(
    () => SplashController(const SecureStorage()),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(
      locator.get<AuthService>(),
      const SecureStorage(),
    ),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(
      locator.get<AuthService>(),
      const SecureStorage(),
    ),
  );

  locator.registerFactory<TransactionRepository>(
      () => TransactionRepositoryImpl());

  locator.registerLazySingleton<HomeController>(
      () => HomeController(locator.get<TransactionRepository>()));
}
