import 'package:get_it/get_it.dart';

import 'features/home/home_controller.dart';
import 'features/home/widgets/balance_card/balance_card_widget_controller.dart';
import 'features/sign_in/sign_in_controller.dart';
import 'features/sign_up/sign_up_controller.dart';
import 'features/splash/splash_controller.dart';
import 'features/transactions/transaction_controller.dart';
import 'features/wallet/wallet_controller.dart';
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

  locator.registerSingletonAsync<GraphQLService>(() async =>
      GraphQLService(authService: locator.get<AuthService>()).init());

  locator.registerFactory<SplashController>(
    () => SplashController(
      secureStorageService: const SecureStorageService(),
    ),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(
      authService: locator.get<AuthService>(),
      secureStorageService: const SecureStorageService(),
    ),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(
      authService: locator.get<AuthService>(),
      secureStorageService: const SecureStorageService(),
    ),
  );

  locator.registerFactory<TransactionRepository>(() =>
      TransactionRepositoryImpl(graphqlService: locator.get<GraphQLService>()));

  locator.registerLazySingleton<HomeController>(() => HomeController(
      transactionRepository: locator.get<TransactionRepository>()));

  locator.registerLazySingleton<BalanceCardWidgetController>(
    () => BalanceCardWidgetController(
      transactionRepository: locator.get<TransactionRepository>(),
    ),
  );

  locator.registerFactory<TransactionController>(
    () => TransactionController(
      transactionRepository: locator.get<TransactionRepository>(),
      storage: const SecureStorageService(),
    ),
  );

  locator.registerLazySingleton(
    () => WalletController(
      transactionRepository: locator.get<TransactionRepository>(),
    ),
  );
}
