import 'package:cloud_functions/cloud_functions.dart';
import 'package:financy_app/features/forgot_password/forgot_password_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'common/features/balance/balance.dart';
import 'common/features/transaction/transaction.dart';
import 'features/home/home_controller.dart';
import 'features/profile/profile_controller.dart';
import 'features/sign_in/sign_in_controller.dart';
import 'features/sign_up/sign_up_controller.dart';
import 'features/splash/splash_controller.dart';
import 'features/stats/stats_controller.dart';
import 'features/wallet/wallet_controller.dart';
import 'repositories/repositories.dart';
import 'services/services.dart';

final locator = GetIt.instance;

void setupDependencies() {
  //Register Services
  locator.registerFactory<AuthService>(
    () => FirebaseAuthService(),
  );

  locator.registerFactory<SecureStorageService>(
      () => const SecureStorageService());

  locator.registerFactory<ConnectionService>(() => const ConnectionService());

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
      connectionService: locator.get<ConnectionService>(),
      databaseService: locator.get<DatabaseService>(),
      graphQLService: locator.get<GraphQLService>(),
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerFactory<UserDataService>(() => UserDataServiceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFunctions: FirebaseFunctions.instance,
      ));

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
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerFactory<SignInController>(
    () => SignInController(
      authService: locator.get<AuthService>(),
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerFactory<SignUpController>(
    () => SignUpController(
      authService: locator.get<AuthService>(),
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerFactory<ForgotPasswordController>(
    () => ForgotPasswordController(authService: locator.get<AuthService>()),
  );

  locator.registerLazySingleton<HomeController>(
    () => HomeController(
      transactionRepository: locator.get<TransactionRepository>(),
      userDataService: locator.get<UserDataService>(),
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
      secureStorageService: locator.get<SecureStorageService>(),
    ),
  );

  locator.registerFactory<SyncController>(
    () => SyncController(
      syncService: locator.get<SyncService>(),
    ),
  );

  locator.registerFactory<ProfileController>(
      () => ProfileController(userDataService: locator.get<UserDataService>()));

  locator.registerLazySingleton<StatsController>(() => StatsController(
      transactionRepository: locator.get<TransactionRepository>()));
}
