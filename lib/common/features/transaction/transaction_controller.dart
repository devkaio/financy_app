import 'package:flutter/foundation.dart';

import '../../../repositories/repositories.dart';
import '../../../services/services.dart';
import '../../models/models.dart';
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

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  void _changeState(TransactionState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _changeState(TransactionStateLoading());

    final data = await storage.readOne(key: 'CURRENT_USER');
    final user = UserModel.fromJson(data ?? '');
    final result = await transactionRepository.addTransaction(
      transaction: transaction,
      userId: user.id!,
    );

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) => _changeState(TransactionStateSuccess()),
    );
  }

  Future<void> getLatestTransactions() async {
    _changeState(TransactionStateLoading());

    final result = await transactionRepository.getTransactions();

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) {
        _transactions = data;
        _transactions.removeWhere((t) => t.syncStatus == SyncStatus.delete);

        _transactions.sort((b, a) => a.date.compareTo(b.date));

        _transactions = _transactions.length > 5
            ? _transactions.getRange(0, 5).toList()
            : _transactions;

        _changeState(TransactionStateSuccess());
      },
    );
  }

  Future<void> getAllTransactions() async {
    _changeState(TransactionStateLoading());

    final result = await transactionRepository.getTransactions();

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) {
        _transactions = data;

        _transactions.sort((a, b) => a.date.compareTo(b.date));

        _transactions.removeWhere((t) => t.syncStatus == SyncStatus.delete);

        _changeState(TransactionStateSuccess());
      },
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

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _changeState(TransactionStateLoading());
    final result = await transactionRepository.deleteTransaction(transaction);

    result.fold(
      (error) => _changeState(TransactionStateError(message: error.message)),
      (data) => _changeState(TransactionStateSuccess()),
    );
  }
}
