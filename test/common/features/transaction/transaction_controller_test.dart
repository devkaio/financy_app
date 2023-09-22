import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/features/transaction/transaction.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/mock_classes.dart';

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late MockSecureStorageService mockSecureStorageService;
  late TransactionController sut;
  late TransactionModel transaction;
  late UserModel user;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockSecureStorageService = MockSecureStorageService();

    sut = TransactionController(
      transactionRepository: mockTransactionRepository,
      secureStorageService: mockSecureStorageService,
    );

    transaction = TransactionModel(
      id: '123',
      category: 'category',
      description: 'description',
      value: 100,
      date: DateTime.now().millisecondsSinceEpoch,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: true,
    );

    user = UserModel(
      id: '123',
      name: 'name',
      email: 'email',
      password: 'password',
    );
  });

  group('Tests TransactionController State', () {
    group('when addTransaction is called', () {
      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: addTransaction is called and the result is a success'
          '\n'
          'THEN: TransactionState should be TransactionStateSuccess', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockSecureStorageService.readOne(key: 'CURRENT_USER'))
            .thenAnswer((_) async => user.toJson());

        when(() => mockTransactionRepository.addTransaction(
              transaction: transaction,
              userId: user.id!,
            )).thenAnswer((_) async => DataResult.success(true));

        // Act
        await sut.addTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateSuccess>());
      });

      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: addTransaction is called and the result is a failure'
          '\n'
          'THEN: TransactionState should be TransactionStateError', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockSecureStorageService.readOne(key: 'CURRENT_USER'))
            .thenAnswer((_) async => user.toJson());

        when(() => mockTransactionRepository.addTransaction(
              transaction: transaction,
              userId: user.id!,
            )).thenAnswer((_) async => DataResult.failure(
              const CacheException(code: 'write'),
            ));

        // Act
        await sut.addTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateError>());
      });
    });

    group('when updateTransaction is called', () {
      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: updateTransaction is called and the result is a success'
          '\n'
          'THEN: TransactionState should be TransactionStateSuccess', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockTransactionRepository.updateTransaction(transaction))
            .thenAnswer((_) async => DataResult.success(true));

        // Act
        await sut.updateTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateSuccess>());
      });

      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: updateTransaction is called and the result is a failure'
          '\n'
          'THEN: TransactionState should be TransactionStateError', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockTransactionRepository.updateTransaction(transaction))
            .thenAnswer((_) async => DataResult.failure(
                  const CacheException(code: 'write'),
                ));

        // Act
        await sut.updateTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateError>());
      });
    });

    group('when deleteTransaction is called', () {
      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: deleteTransaction is called and the result is a success'
          '\n'
          'THEN: TransactionState should be TransactionStateSuccess', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockTransactionRepository.deleteTransaction(transaction))
            .thenAnswer((_) async => DataResult.success(true));

        // Act
        await sut.deleteTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateSuccess>());
      });

      test(
          '\n'
          'GIVEN: that the initial state is TransactionStateInitial'
          '\n'
          'WHEN: deleteTransaction is called and the result is a failure'
          '\n'
          'THEN: TransactionState should be TransactionStateError', () async {
        // Arrange
        expect(sut.state, isA<TransactionStateInitial>());

        when(() => mockTransactionRepository.deleteTransaction(transaction))
            .thenAnswer((_) async => DataResult.failure(
                  const CacheException(code: 'write'),
                ));

        // Act
        await sut.deleteTransaction(transaction);

        // Assert
        expect(sut.state, isA<TransactionStateError>());
      });
    });
  });
}
