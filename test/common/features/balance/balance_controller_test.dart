import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/features/balance/balance.dart';
import 'package:financy_app/common/models/balances_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/mock_classes.dart';

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late BalanceController sut;
  late BalancesModel emptyBalance;
  late BalancesModel filledBalance;
  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    sut = BalanceController(
      transactionRepository: mockTransactionRepository,
    );
    emptyBalance = BalancesModel(
      totalIncome: 0,
      totalOutcome: 0,
      totalBalance: 0,
    );

    filledBalance = BalancesModel(
      totalIncome: 100,
      totalOutcome: -50,
      totalBalance: 50,
    );
  });
  group('Tests BalanceController State', () {
    test(
        '\n'
        'GIVEN: that the initial state is BalanceStateInitial'
        '\n'
        'WHEN: getBalances is called and returns empty balances'
        '\n'
        'THEN: BalanceState should be BalanceStateSuccess and balance is empty',
        () async {
      // Arrange
      expect(sut.state, isA<BalanceStateInitial>());
      when(() => mockTransactionRepository.getBalances()).thenAnswer(
        (_) async => DataResult.success(emptyBalance),
      );

      // Act
      await sut.getBalances();

      // Assert
      expect(sut.balances, emptyBalance);
      expect(sut.balances.totalBalance, 0);
      expect(sut.balances.totalIncome, 0);
      expect(sut.balances.totalOutcome, 0);
      expect(sut.state, isA<BalanceStateSuccess>());
    });
  });

  test(
    '\n'
    'GIVEN: that the initial state is BalanceStateInitial'
    '\n'
    'WHEN: getBalances is called and returns filled balances'
    '\n'
    'THEN: BalanceState should be BalanceStateSuccess and balance should not be empty',
    () async {
      // Arrange
      expect(sut.state, isA<BalanceStateInitial>());
      when(() => mockTransactionRepository.getBalances())
          .thenAnswer((_) async => DataResult.success(filledBalance));

      // Act
      await sut.getBalances();

      // Assert
      expect(sut.balances, isNot(emptyBalance));
      expect(sut.balances.totalBalance, isNot(emptyBalance.totalBalance));
      expect(sut.balances.totalBalance, 50);
      expect(sut.balances.totalIncome, isNot(emptyBalance.totalIncome));
      expect(sut.balances.totalIncome, 100);
      expect(sut.balances.totalOutcome, isNot(emptyBalance.totalOutcome));
      expect(sut.balances.totalOutcome, -50);

      expect(sut.state, isA<BalanceStateSuccess>());
    },
  );

  test(
      '\n'
      'GIVEN: that the initial state is BalanceStateInitial'
      '\n'
      'WHEN: getBalances is called and returns Failure'
      '\n'
      'THEN: BalanceState should be BalanceStateError and balance should be empty',
      () async {
    // Arrange
    expect(sut.state, isA<BalanceStateInitial>());
    when(() => mockTransactionRepository.getBalances()).thenAnswer(
        (_) async => DataResult.failure(const CacheException(code: 'error')));

    // Act
    await sut.getBalances();

    // Assert
    expect(sut.balances.totalBalance, 0);
    expect(sut.balances.totalIncome, 0);
    expect(sut.balances.totalOutcome, 0);
    expect(sut.state, isA<BalanceStateError>());
  });
}
