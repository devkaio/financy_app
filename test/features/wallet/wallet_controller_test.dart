import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/features/wallet/wallet_controller.dart';
import 'package:financy_app/features/wallet/wallet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockTransactionRepository mockTransactionRepository;

  late WalletController sut;
  late List<TransactionModel> transactions;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();

    sut = WalletController(
      transactionRepository: mockTransactionRepository,
    );

    transactions = [
      TransactionModel.fromMap({
        'id': '1',
        'title': 'title',
        'description': 'description',
        'value': 10.0,
        'date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'status': false,
        'type': 'expense',
        'category': 'category',
        'user_id': '1'
      }),
    ];
  });

  group('Tests Wallet Controller State', () {
    test('''
\nGiven: that the initial state is WalletStateInitial
When: getAllTransactions is called and returns transactions
Then: WalletState should be WalletStateSuccess
''', () async {
      expect(sut.state, isInstanceOf<WalletStateInitial>());
      expect(sut.transactions, isEmpty);

      when(() => mockTransactionRepository.getLatestTransactions()).thenAnswer(
        (_) async => DataResult.success(transactions),
      );

      await sut.getAllTransactions();

      expect(sut.transactions, isNotEmpty);

      expect(sut.state, isInstanceOf<WalletStateSuccess>());
    });

    test('''
\nGiven: that the initial state is WalletStateInitial
When: getAllTransactions is called and returns failure
Then: WalletState should be WalletStateError
''', () async {
      expect(sut.state, isInstanceOf<WalletStateInitial>());
      expect(sut.transactions, isEmpty);

      when(() => mockTransactionRepository.getLatestTransactions()).thenAnswer(
        (_) async => DataResult.failure(const GeneralException()),
      );

      await sut.getAllTransactions();

      expect(sut.transactions, isEmpty);

      expect(sut.state, isInstanceOf<WalletStateError>());
    });
  });
}
