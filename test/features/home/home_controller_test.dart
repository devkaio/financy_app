import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/features/home/home_controller.dart';
import 'package:financy_app/features/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late MockSyncService mockSyncService;
  late MockUserDataService mockUserDataService;

  late HomeController sut;
  late List<TransactionModel> transactions;

  setUp(() {
    mockSyncService = MockSyncService();
    mockTransactionRepository = MockTransactionRepository();
    mockUserDataService = MockUserDataService();

    sut = HomeController(
      transactionRepository: mockTransactionRepository,
      userDataService: mockUserDataService,
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

    when(() => mockSyncService.syncFromServer())
        .thenAnswer((_) async => DataResult.success(null));
  });

  group('Tests Home Controller State', () {
    test('''
\nGiven: that the initial state is HomeStateInitial
When: getLatestTransactions is called and returns transactions
Then: HomeState should be HomeStateSuccess
''', () async {
      expect(sut.state, isInstanceOf<HomeStateInitial>());
      expect(sut.transactions, isEmpty);

      when(() => mockTransactionRepository.getLatestTransactions()).thenAnswer(
        (_) async => DataResult.success(transactions),
      );

      await sut.getLatestTransactions();

      expect(sut.transactions, isNotEmpty);

      expect(sut.state, isInstanceOf<HomeStateSuccess>());
    });

    test('''
\nGiven: that the initial state is HomeStateInitial
When: getLatestTransactions is called and returns failure
Then: HomeState should be HomeStateError
''', () async {
      expect(sut.state, isInstanceOf<HomeStateInitial>());
      expect(sut.transactions, isEmpty);

      when(() => mockTransactionRepository.getLatestTransactions()).thenAnswer(
        (_) async => DataResult.failure(const GeneralException()),
      );

      await sut.getLatestTransactions();

      expect(sut.transactions, isEmpty);

      expect(sut.state, isInstanceOf<HomeStateError>());
    });
  });
}
