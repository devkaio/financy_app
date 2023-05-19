import '../common/models/user_model.dart';
import '../data/data_result.dart';

abstract class AuthService {
  Future<DataResult<UserModel>> signUp({
    String? name,
    required String email,
    required String password,
  });

  Future<DataResult<UserModel>> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<DataResult<String>> userToken();
}
