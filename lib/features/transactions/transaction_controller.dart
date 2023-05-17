import 'package:flutter/foundation.dart';

import '../../common/models/transaction_model.dart';
import '../../common/models/user_model.dart';
import '../../repositories/transaction_repository.dart';
import '../../services/secure_storage.dart';
import 'transaction_state.dart';

class TransactionController extends ChangeNotifier {
  TransactionController({
    required this.transactionRepository,
    required this.storage,
  });

  final SecureStorageService storage;
  final TransactionRepository transactionRepository;

  TransactionState _state = TransactionStateInitial();

  TransactionState get state => _state;

  void _changeState(TransactionState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _changeState(TransactionStateLoading());

    final data = await storage.readOne(key: 'CURRENT_USER');
    final user = UserModel.fromJson(data ?? '');
    final result = await transactionRepository.addTransaction(
      transaction,
      user.id!,
    );

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) => _changeState(TransactionStateSuccess()),
    );
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    _changeState(TransactionStateLoading());
    final result = await transactionRepository.updateTransaction(transaction);

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) => _changeState(TransactionStateSuccess()),
    );
  }
}
