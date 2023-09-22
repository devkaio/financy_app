import 'package:flutter/foundation.dart';

import '../../common/models/transaction_model.dart';
import '../../repositories/transaction_repository.dart';
import 'wallet_state.dart';

class WalletController extends ChangeNotifier {
  WalletController({
    required this.transactionRepository,
  });

  final TransactionRepository transactionRepository;

  WalletState _state = WalletStateInitial();

  WalletState get state => _state;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  void _changeState(WalletState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    _changeState(WalletStateLoading());

    final result = await transactionRepository.getLatestTransactions();

    result.fold(
      (error) => _changeState(WalletStateError(message: error.message)),
      (data) {
        _transactions = data;

        _changeState(WalletStateSuccess());
      },
    );
  }

  void changeSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
  }

  Future<void> getTransactionsByDateRange() async {
    _changeState(WalletStateLoading());

    final result = await transactionRepository.getTransactionsByDateRange(
      startDate: _selectedDate.copyWith(day: 1),
      endDate: _selectedDate.copyWith(
        day: DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day,
      ),
    );

    result.fold(
      (error) => _changeState(WalletStateError(message: error.message)),
      (data) {
        _transactions = data;

        _changeState(WalletStateSuccess());
      },
    );
  }
}
