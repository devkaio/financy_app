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

      test(
          '\n'
          'GIVEN: a transaction and user ID'
          '\n'
          'WHEN: adding a new transaction and the sync service throws an error'
          '\n'
          'THEN: it should return a failure result', () async {
        //WHEN
        when(() => mockSyncService.saveLocalChanges(
              path: TransactionRepository.transactionsPath,
              params: any(named: 'params'),
            )).thenThrow(const CacheException(code: 'write'));

        final result = await transactionRepositoryImpl.addTransaction(
          transaction: TransactionModel.fromMap(transactionMap),
          userId: userId,
        );

        //THEN
        result.fold(
          (error) {
            expect(error, isA<Failure>());
            expect(error.message,
                'An error has occurred while writing data into local cache.');
          },
          (data) => expect(data, null),
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

        final result = await transactionRepositoryImpl.getLatestTransactions();

        //THEN
        result.fold(
          (error) => expect(error, null),
          (data) {
            expect(data, isA<List<TransactionModel>>());
            expect(data.length, 2);
          },
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

        final result = await transactionRepositoryImpl.getLatestTransactions();

        //THEN
        result.fold(
          (error) => expect(error, null),
          (data) => expect(data, isEmpty),
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

        final result = await transactionRepositoryImpl.getLatestTransactions();

        //THEN
        result.fold(
          (error) {
            expect(error, isA<Failure>());
            expect(error.message,
                'An error has occurred while reading data into local cache.');
          },
          (data) => expect(data, null),
        );
      });
    });

    group('when deleteTransaction is called', () {
      test(
          '\n'
          'GIVEN: a transaction exists in the database'
          '\n'
          'WHEN: deleteTransaction is called'
          '\n'
          'THEN: deleteTransaction should return true', () async {
        //WHEN
        when(
          () => mockDatabaseService.delete(
              path: TransactionRepository.transactionsPath,
              params: {'id': transactionMap['id']}),
        ).thenAnswer((_) async => {'data': true});

        when(() => mockSyncService.saveLocalChanges(
            path: TransactionRepository.transactionsPath,
            params: TransactionModel.fromMap(transactionMap)
                .copyWith(syncStatus: SyncStatus.delete)
                .toDatabase())).thenAnswer((_) async {});

        // Act
        final result = await transactionRepositoryImpl
            .deleteTransaction(TransactionModel.fromMap(transactionMap));

        result.fold(
          (error) => null,
          (data) {
            expect(data, true);
          },
        );
      });

      test(
          '\n'
          'GIVEN: a transaction exists in the database'
          '\n'
          'WHEN: deleteTransaction is called and the database throws exception'
          '\n'
          'THEN: deleteTransaction should return false', () async {
        //WHEN
        when(
          () => mockDatabaseService.delete(
              path: TransactionRepository.transactionsPath,
              params: {'id': transactionMap['id']}),
        ).thenThrow(const CacheException(code: 'delete'));

        // Act
        final result = await transactionRepositoryImpl
            .deleteTransaction(TransactionModel.fromMap(transactionMap));

        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while delete data from local cache.');
          },
          (data) => expect(data, null),
        );
      });

      test(
          '\n'
          'GIVEN: a transaction exists in the database'
          '\n'
          'WHEN: deleteTransaction is called and the syncService throws exception'
          '\n'
          'THEN: deleteTransaction should return false', () async {
        //WHEN
        when(
          () => mockDatabaseService.delete(
              path: TransactionRepository.transactionsPath,
              params: {'id': transactionMap['id']}),
        ).thenAnswer((_) async => {'data': true});

        when(() => mockSyncService.saveLocalChanges(
            path: TransactionRepository.transactionsPath,
            params: TransactionModel.fromMap(transactionMap)
                .copyWith(syncStatus: SyncStatus.delete)
                .toDatabase())).thenThrow(const CacheException(code: 'write'));

        // Act
        final result = await transactionRepositoryImpl
            .deleteTransaction(TransactionModel.fromMap(transactionMap));

        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while writing data into local cache.');
          },
          (data) => expect(data, null),
        );
      });
    });

    group('when updateTransaction is called', () {
      test('should return true when transaction is saved in database',
          () async {
        //WHEN
        when(() => mockSyncService.saveLocalChanges(
            path: TransactionRepository.transactionsPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async {});

        // Act
        final result = await transactionRepositoryImpl
            .updateTransaction(TransactionModel.fromMap(transactionMap));

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data, true);
          },
        );
      });

      test('should return failure when sycncService throws exception',
          () async {
        //WHEN
        when(() => mockSyncService.saveLocalChanges(
            path: TransactionRepository.transactionsPath,
            params: any(
              named: 'params',
            ))).thenThrow(const CacheException(code: 'write'));

        // Act
        final result = await transactionRepositoryImpl
            .updateTransaction(TransactionModel.fromMap(transactionMap));

        // Assert
        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while writing data into local cache.');
          },
          (data) => expect(data, null),
        );
      });
    });
    group('when updateBalance is called', () {
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

        //WHEN
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

        // Assert before update
        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, -200);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -300);
          },
        );

        // Arrange
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

      test(
          'Update balance when an income transaction of value 100 is updated to 200',
          () async {
        // Arrange
        balancesMap = {
          'data': [
            {
              'total_balance': 0,
              'total_income': 100,
              'total_outcome': -100,
            }
          ]
        };
        //WHEN
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

        // Assert before update
        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 0);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -100);
          },
        );

        // Arrange
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

        final updatedTransaction = oldTransaction.copyWith(value: 200);

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: updatedTransaction,
        );

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 100);
            expect(data.totalIncome, 200);
            expect(data.totalOutcome, -100);
          },
        );
      });

      test(
          'Update balance when an outcome transaction of value -100 is updated to -300',
          () async {
        // Arrange
        balancesMap = {
          'data': [
            {
              'total_balance': 0,
              'total_income': 100,
              'total_outcome': -100,
            }
          ]
        };
        //WHEN
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

        // Assert before update
        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 0);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -100);
          },
        );

        // Arrange
        final oldTransaction = TransactionModel(
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

        final updatedTransaction = oldTransaction.copyWith(value: -300);

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: updatedTransaction,
        );

        // Assert
        result.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, -200);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -300);
          },
        );
      });

      test(
          'Update balance when an income transaction is updated to an outcome transaction',
          () async {
        // Arrange
        balancesMap = {
          'data': [
            {
              'total_balance': 0,
              'total_income': 100,
              'total_outcome': -100,
            }
          ]
        };
        //WHEN
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

        // Assert before update
        initialBalance.fold(
          (error) => null,
          (data) {
            expect(data.totalBalance, 0);
            expect(data.totalIncome, 100);
            expect(data.totalOutcome, -100);
          },
        );

        // Arrange
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

        final updatedTransaction = oldTransaction.copyWith(value: -200);

        // Act
        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: updatedTransaction,
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

      test('and database throws exception when reading balance on update',
          () async {
        //WHEN
        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenThrow(const CacheException(code: 'read'));

        final oldTransaction = TransactionModel.fromMap(transactionMap);
        final newTransaction = oldTransaction.copyWith(value: 200);

        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: newTransaction,
        );

        // Assert
        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while reading data into local cache.');
          },
          (data) => null,
        );
      });
      test('and database throws exception when updating balance', () async {
        //WHEN
        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenAnswer((_) async => balancesMap);
        when(() => mockDatabaseService.update(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenThrow(const CacheException(code: 'update'));

        final oldTransaction = TransactionModel.fromMap(transactionMap);
        final newTransaction = oldTransaction.copyWith(value: 200);

        final result = await transactionRepositoryImpl.updateBalance(
          oldTransaction: oldTransaction,
          newTransaction: newTransaction,
        );

        // Assert
        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while updating data from local cache.');
          },
          (data) => null,
        );
      });

      test('and database throws exception when reading balance', () async {
        //WHEN
        when(() => mockDatabaseService.read(
            path: TransactionRepository.balancesPath,
            params: any(
              named: 'params',
            ))).thenThrow(const CacheException(code: 'read'));

        final result = await transactionRepositoryImpl.getBalances();

        // Assert
        result.fold(
          (error) {
            expect(error, isA<CacheException>());
            expect(error.message,
                'An error has occurred while reading data into local cache.');
          },
          (data) => null,
        );
      });
    });
  });
}
