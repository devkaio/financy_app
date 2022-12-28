import 'package:financy_app/services/auth_service.dart';
import 'package:financy_app/services/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements AuthService {}

class MockSecureStorage extends Mock implements SecureStorage {}
