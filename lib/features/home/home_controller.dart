import 'package:flutter/material.dart';

import '../../common/models/transaction_model.dart';
import '../../repositories/transaction_repository.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  final TransactionRepository _transactionRepository;
  HomeController(this._transactionRepository);

  HomeState _state = HomeStateInitial();

  HomeState get state => _state;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  late PageController _pageController;
  PageController get pageController => _pageController;

  set setPageController(PageController newPageController) {
    _pageController = newPageController;
  }

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    _changeState(HomeStateLoading());
    try {
      _transactions = await _transactionRepository.getAllTransactions();
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }
}
