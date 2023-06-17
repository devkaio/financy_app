import 'package:get_it/get_it.dart';

import 'common/features/balance/balance.dart';
import 'common/features/transaction/transaction.dart';
import 'features/home/home_controller.dart';
import 'features/sign_in/sign_in_controller.dart';
import 'features/sign_up/sign_up_controller.dart';
import 'features/splash/splash_controller.dart';
import 'features/wallet/wallet_controller.dart';
import 'repositories/repositories.dart';
import 'services/services.dart';

final locator = GetIt.instance;

void setupDependencies() {
  //Register Services
  locator.registerFactory<AuthService>(
    () => FirebaseAuthService(),
  );

  locator.registerSingletonAsync<GraphQLService>(
    () async => GraphQLService(
      authService: locator.get<AuthService>(),
    ).init(),
  );

  locator.registerSingletonAsync<DatabaseService>(
    () async => DatabaseService().init(),
  );

  locator.registerFactory<SyncService>(
    () => SyncService(
      connectionService: const ConnectionService(),
      databaseService: locator.get<DatabaseService>(),
      graphQLService: locator.get<GraphQLService>(),
      secureStorageService: const SecureStorageService(),
    ),
  );

  //Register Repositories

  locator.registerFactory<TransactionRepository>(
    () => TransactionRepositoryImpl(
      databaseService: locator.get<DatabaseService>(),
      syncService: locator.get<SyncService>(),
    ),
  );

  //Register Controllers

  locator.registerFactory<SplashController>(
    () => SplashController(
      secureStorageService: const SecureStorageService(),
      syncService: locator.get<SyncService>(),
    ),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(
      authService: locator.get<AuthService>(),
      secureStorageService: const SecureStorageService(),
      syncService: locator.get<SyncService>(),
    ),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(
      authService: locator.get<AuthService>(),
      secureStorageService: const SecureStorageService(),
    ),
  );

  locator.registerLazySingleton<HomeController>(
    () => HomeController(
      transactionRepository: locator.get<TransactionRepository>(),
      syncService: SyncService(
        connectionService: const ConnectionService(),
        databaseService: locator.get<DatabaseService>(),
        graphQLService: locator.get<GraphQLService>(),
        secureStorageService: const SecureStorageService(),
      ),
    ),
  );

  locator.registerLazySingleton<WalletController>(
    () => WalletController(
      transactionRepository: locator.get<TransactionRepository>(),
    ),
  );

  locator.registerLazySingleton<BalanceController>(
    () => BalanceController(
      transactionRepository: locator.get<TransactionRepository>(),
    ),
  );

  locator.registerLazySingleton<TransactionController>(
    () => TransactionController(
      transactionRepository: locator.get<TransactionRepository>(),
      storage: const SecureStorageService(),
    ),
  );
}
