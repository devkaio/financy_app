import 'package:cloud_functions/cloud_functions.dart';
import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/repositories/repositories.dart';
import 'package:financy_app/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

// Mock Models

class MockUser extends Mock implements UserModel {}

// Mock Services
class MockFirebaseAuthService extends Mock implements AuthService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockGraphQLService extends Mock implements GraphQLService {}

class MockSyncService extends Mock implements SyncService {}

class MockUserDataService extends Mock implements UserDataService {}

// Mock Repositories

class MockTransactionRepository extends Mock implements TransactionRepository {}

// Mock FirebaseAuth

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class FakeUser extends Fake implements User {
  @override
  String get uid => '123456abc';

  @override
  String get displayName => 'User';

  @override
  String get email => 'user@email.com';
}

// Mock FirebaseFunctions

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}
