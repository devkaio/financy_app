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

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  int get _limit => 10;
  int get _offset => transactions.isEmpty ? 0 : transactions.length;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  void _changeState(WalletState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    _changeState(WalletStateLoading());

    if (transactions.isNotEmpty) transactions.clear();

    final result = await transactionRepository.getTransactions(
      limit: _limit,
      offset: _offset,
    );

    result.fold(
      (error) => _changeState(WalletStateError(message: error.message)),
      (data) {
        _transactions = data;

        _changeState(WalletStateSuccess());
      },
    );

    if (_offset >= _limit) {
      _isLoading = true;
    }
  }

  void get fetchMore async {
    if (isLoading) {
      final result = await transactionRepository.getTransactions(
        limit: _limit,
        offset: _offset,
      );

      result.fold(
        (error) => _changeState(WalletStateError(message: error.message)),
        (data) {
          if (data.isNotEmpty) {
            _transactions.addAll(data);
          } else {
            _isLoading = false;
          }

          _changeState(WalletStateSuccess());
        },
      );
    }
  }
}
