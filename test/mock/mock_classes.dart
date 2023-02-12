import 'package:financy_app/common/models/user_model.dart';
import 'package:financy_app/services/auth_service.dart';
import 'package:financy_app/services/graphql_service.dart';
import 'package:financy_app/services/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements AuthService {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockGraphQLService extends Mock implements GraphQLService {}

class MockUser extends Mock implements UserModel {}
