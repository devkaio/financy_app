import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _functions = FirebaseFunctions.instance;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        return UserModel(
          name: _auth.currentUser?.displayName,
          email: _auth.currentUser?.email,
          id: _auth.currentUser?.uid,
        );
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "null";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      await _functions.httpsCallable('registerUser').call({
        "email": email,
        "password": password,
        "displayName": name,
      });

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return UserModel(
          name: _auth.currentUser?.displayName,
          email: _auth.currentUser?.email,
          id: _auth.currentUser?.uid,
        );
      } else {
        throw Exception();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "null";
    } on FirebaseFunctionsException catch (e) {
      throw e.message ?? "null";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> get userToken async {
    try {
      final token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        return token;
      } else {
        throw Exception('user not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}
