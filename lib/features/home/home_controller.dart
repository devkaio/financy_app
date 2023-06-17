import 'package:flutter/material.dart';

import '../../common/models/models.dart';
import '../../repositories/repositories.dart';
import '../../services/sync_service.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this.transactionRepository,
    required this.syncService,
  });

  final TransactionRepository transactionRepository;
  final SyncService syncService;

  HomeState _state = HomeStateInitial();

  HomeState get state => _state;

  late PageController _pageController;
  PageController get pageController => _pageController;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  set setPageController(PageController newPageController) {
    _pageController = newPageController;
  }

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getLatestTransactions() async {
    _changeState(HomeStateLoading());

    final result = await transactionRepository.getTransactions(
      limit: 5,
      latest: true,
    );

    result.fold(
      (error) => _changeState(HomeStateError(message: error.message)),
      (data) {
        _transactions = data;

        _changeState(HomeStateSuccess());
      },
    );
  }
}
