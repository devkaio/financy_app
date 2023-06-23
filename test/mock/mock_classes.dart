import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/repositories/repositories.dart';
import 'package:financy_app/services/services.dart';
import 'package:mocktail/mocktail.dart';

// Mock Models

class MockUser extends Mock implements UserModel {}

// Mock Services
class MockFirebaseAuthService extends Mock implements AuthService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockGraphQLService extends Mock implements GraphQLService {}

class MockSyncService extends Mock implements SyncService {}

// Mock Repositories

class MockTransactionRepository extends Mock implements TransactionRepository {}
