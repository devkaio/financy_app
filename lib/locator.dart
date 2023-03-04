import 'package:get_it/get_it.dart';

import 'features/home/home_controller.dart';
import 'features/home/widgets/balance_card/balance_card_widget_controller.dart';
import 'features/sign_in/sign_in_controller.dart';
import 'features/sign_up/sign_up_controller.dart';
import 'features/splash/splash_controller.dart';
import 'repositories/transaction_repository.dart';
import 'services/auth_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/graphql_service.dart';
import 'services/secure_storage.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerFactory<AuthService>(
    () => FirebaseAuthService(),
  );

  locator.registerLazySingleton<GraphQLService>(
      () => GraphQLService(authService: locator.get<AuthService>()));

  locator.registerFactory<SplashController>(
    () => SplashController(
      secureStorage: const SecureStorage(),
      graphQLService: locator.get<GraphQLService>(),
    ),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(
      authService: locator.get<AuthService>(),
      secureStorage: const SecureStorage(),
      graphQLService: locator.get<GraphQLService>(),
    ),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(
      authService: locator.get<AuthService>(),
      secureStorage: const SecureStorage(),
      graphQLService: locator.get<GraphQLService>(),
    ),
  );

  locator.registerFactory<TransactionRepository>(
      () => TransactionRepositoryImpl());

  locator.registerLazySingleton<HomeController>(
      () => HomeController(locator.get<TransactionRepository>()));

  locator.registerLazySingleton<BalanceCardWidgetController>(
    () => BalanceCardWidgetController(
      transactionRepository: locator.get<TransactionRepository>(),
    ),
  );
}
