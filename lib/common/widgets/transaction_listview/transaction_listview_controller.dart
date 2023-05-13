import 'package:financy_app/common/models/transaction_model.dart';
import 'package:financy_app/repositories/transaction_repository.dart';
import 'package:flutter/foundation.dart';

import 'transaction_listview_state.dart';

class TransactionListViewController extends ChangeNotifier {
  TransactionListViewController({
    required this.transactionRepository,
  });

  final TransactionRepository transactionRepository;
  TransactionListViewState _state = TransactionListViewStateInitial();

  TransactionListViewState get state => _state;

  void _changeState(TransactionListViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _changeState(TransactionListViewStateLoading());
    final result =
        await transactionRepository.deleteTransaction(transaction.id!);

    result.fold(
      (error) => _changeState(TransactionListViewStateError(error.message)),
      (data) => _changeState(TransactionListViewStateSuccess()),
    );
  }
}
