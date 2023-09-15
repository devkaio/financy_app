import '../../common/data/data_result.dart';
import '../../common/models/models.dart';

abstract class UserDataService {
  Future<DataResult<UserModel>> getUserData();

  Future<DataResult<UserModel>> updateUserName(String newUserName);

  Future<DataResult<bool>> updatePassword(String newPassword);

  Future<DataResult<bool>> deleteAccount();

  UserModel get userData;
}
