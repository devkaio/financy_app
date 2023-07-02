import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock_classes.dart';

void main() {
  late TransactionRepository transactionRepositoryImpl;
  late MockDatabaseService mockDatabaseService;
  late MockSyncService mockSyncService;
  late List<Map<String, dynamic>> transactionsList;
  late Map<String, dynamic> transactionMap;
  late Map<String, dynamic> balancesMap;
  late String userId;

  setUp(() {
    //GIVEN
    mockDatabaseService = MockDatabaseService();
    mockSyncService = MockSyncService();
    (mockDatabaseService);
    transactionRepositoryImpl = TransactionRepositoryImpl(
      databaseService: mockDatabaseService,
      syncService: mockSyncService,
    );
    userId = '1';
    transactionsList = [
      {
        'description': 'description',
        'category': 'category',
        'value': 100,
        'date': DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)
            .toIso8601String(),
        'created_at': DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)
            .toIso8601String(),
        'status': true,
        'id': '1',
        'user_id': userId,
      },
      {
        'description': 'description',
        'category': 'category',
        'value': 200,
        'date': DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)
            .toIso8601String(),
        'created_at': DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)
            .toIso8601String(),
        'status': true,
        'id': '2',
        'user_id': userId,
      },
    ];

    transactionMap = {
      'description': 'description',
      'category': 'category',
      'value': 200,
      'date': DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch)
          .toIso8601String(),
      'created_at': DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch)
          .toIso8601String(),
      'status': true,
      'id': '1',
      'user_id': userId,
    };

    balancesMap = {
      'data': [
        {
          'total_balance': 0,
          'total_income': 0,
          'total_outcome': 0,
        }
      ]
    };
  });
  group('Tests Transaction Repository', () {
    group('when addTransaction is called', () {
      test(
          '\n'
          'GIVEN: a transaction and user ID'
          '\n'
          'WHEN: adding a transaction'
          '\n'
          'THEN: it should return a success result', () async {
        //WHEN
        when(() => mockDatabaseService.read(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {'data': []});

        when(() => mockDatabaseService.read(
              path: TransactionRepository.balancesPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => balancesMap);

        when(() => mockDatabaseService.update(
              path: TransactionRepository.balancesPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {'data': true});

        when(() => mockSyncService.saveLocalChanges(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {});

        final result = await transactionRepositoryImpl.addTransaction(
          transaction: TransactionModel.fromMap(transactionMap),
          userId: userId,
        );

        //THEN
        result.fold(
          (error) => expect(error, null),
          (data) => expect(data, true),
        );
      });
    });

    group('when getTransactions is called', () {
      test(
          '\n'
          'GIVEN: the user has transactions'
          '\n'
          'WHEN: getting the transactions'
          '\n'
          'THEN: it should return a list of transactions', () async {
        //WHEN
        when(() => mockDatabaseService.read(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {'data': transactionsList});

        final result = await transactionRepositoryImpl.getTransactions();

        //THEN
        result.fold(
          (error) => expect(error, null),
          (data) => expect(data.length, 2),
        );
      });

      test(
          '\n'
          'GIVEN: the user has no transactions'
          '\n'
          'WHEN: getting the transactions'
          '\n'
          'THEN: it should return an empty list', () async {
        //WHEN
        when(() => mockDatabaseService.read(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {'data': []});

        final result = await transactionRepositoryImpl.getTransactions();

        //THEN
        result.fold(
          (error) => expect(error, null),
          (data) => expect(data.length, 0),
        );
      });

      test(
          '\n'
          'GIVEN: that the database service throws an error'
          '\n'
          'WHEN: getting transactions'
          '\n'
          'THEN: it should return a failure result', () async {
        //WHEN
        when(() => mockDatabaseService.read(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenThrow(const CacheException(code: 'read'));

        final result = await transactionRepositoryImpl.getTransactions();

        //THEN
        result.fold(
          (error) => expect(error, isA<Failure>()),
          (data) => expect(data, null),
        );
      });
    });

    group('when updateTransaction is called', () {
      test('Update balance when a transaction is deleted', () async {
        // Arrange
        balancesMap = {
          'data': [
            {
              'total_balance': -200,
              'total_income': 100,
              'total_outcome': -300,
            }
          ]
        };

        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => balancesMap);

        when(() => mockDatabaseService.update(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => {'data': true});

        final initialBalance = await transactionRepositoryImpl.getBalances();

        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, -200);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -300);
          },
        );

        // Define the old transaction
        final oldTransaction = TransactionModel(
          category: 'category',
          description: 'description',
          value: 100,
          date: DateTime.now().millisecondsSinceEpoch,
          status: true,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: '1',
          syncStatus: SyncStatus.synced,
          userId: userId,
        );
        // Define the new transaction
        final newTransaction = oldTransaction.copyWith(value: 0);

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: newTransaction,
        );

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, -300);
            expect(data.totalIncome, 0);
            expect(data.totalOutcome, -300);
          },
        );
      });

      test('Update balance when new income is added', () async {
        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => balancesMap);

        when(() => mockDatabaseService.update(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => {'data': true});

        final initialBalance = await transactionRepositoryImpl.getBalances();

        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 0);
            expect(data.totalIncome, 0);
            expect(data.totalOutcome, 0);
          },
        );

        // Define the new transaction
        final newTransaction = TransactionModel(
          category: 'category',
          description: 'description',
          value: 100,
          date: DateTime.now().millisecondsSinceEpoch,
          status: true,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: '1',
          syncStatus: SyncStatus.synced,
          userId: userId,
        );

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          newTransaction: newTransaction,
        );

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 100);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, 0);
          },
        );
      });

      test('Update balance when new outcome is added', () async {
        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => balancesMap);

        when(() => mockDatabaseService.update(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => {'data': true});

        final initialBalance = await transactionRepositoryImpl.getBalances();

        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 0);
            expect(data.totalIncome, 0);
            expect(data.totalOutcome, 0);
          },
        );

        // Define the new transaction
        final newTransaction = TransactionModel(
          category: 'category',
          description: 'description',
          value: -100,
          date: DateTime.now().millisecondsSinceEpoch,
          status: true,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: '1',
          syncStatus: SyncStatus.synced,
          userId: userId,
        );

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          newTransaction: newTransaction,
        );

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, -100);
            expect(data.totalIncome, 0);
            expect(data.totalOutcome, -100);
          },
        );
      });
    });

    group('when deleteTransaction is called', () {
      test(
          '\n'
          'GIVEN: that the balance is empty'
          '\n'
          'WHEN: a new transaction of 50 is added'
          '\n'
          'THEN: the total balance should be 200, total income should be 200 and total outcome should be 0',
          () async {
        //WHEN
        when(() => mockDatabaseService.read(
              path: TransactionRepository.balancesPath,
              params: any(named: 'params'),
            )).thenAnswer((_) async => {
              'data': [
                {
                  'total_value': 0,
                  'total_income': 0,
                  'total_expense': 0,
                }
              ]
            });

        when(
          () => mockDatabaseService.read(
              path: TransactionRepository.transactionsPath,
              params: {'id': transactionMap['id']}),
        ).thenAnswer((_) async => {'data': []});
      });
    });
  });
}
