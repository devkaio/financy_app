import 'package:financy_app/common/data/data_result.dart';
import 'package:financy_app/common/models/models.dart';

abstract class UserDataService {
  Future<DataResult<UserModel>> getUserData();

  Future<DataResult<UserModel>> updateUserName(String newUserName);

  Future<DataResult<bool>> updatePassword(String newPassword);

  UserModel get userData;
}
