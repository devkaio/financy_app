import 'package:flutter/material.dart';

import '../../common/models/transaction_model.dart';
import '../../repositories/transaction_repository.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this.transactionRepository,
  });

  final TransactionRepository transactionRepository;

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

  Future<void> getLatestTransactions() async {
    _changeState(HomeStateLoading());

    final result = await transactionRepository.getTransactions(limit: 5);

    result.fold(
      (error) => _changeState(HomeStateError(message: error.message)),
      (data) {
        _transactions = data;
        _changeState(HomeStateSuccess());
      },
    );
  }
}
