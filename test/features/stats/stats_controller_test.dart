import 'package:financy_app/common/data/data.dart';
import 'package:financy_app/common/extensions/extensions.dart';
import 'package:financy_app/common/models/models.dart';
import 'package:financy_app/features/stats/stats_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock_classes.dart';

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late StatsController sut;
  late List<TransactionModel> transactions;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    sut = StatsController(
      transactionRepository: mockTransactionRepository,
    );
    transactions = [
      TransactionModel.fromMap({
        'description': 'description',
        'category': 'category 1',
        'value': 100.0,
        'date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'status': true,
        'id': '1',
        'user_id': '1',
      }),
      TransactionModel.fromMap({
        'description': 'description',
        'category': 'category 2',
        'value': 100.0,
        'date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'status': true,
        'id': '2',
        'user_id': '1',
      }),
    ];
  });

  group('WHEN getTrasactionsByPeriod is called', () {
    test('and the period is StatsPeriod.day', () async {
      when(
        () => mockTransactionRepository.getTransactionsByDateRange(
            startDate: any(named: 'startDate'), endDate: any(named: 'endDate')),
      ).thenAnswer((_) async => DataResult.success(transactions));

      await sut.getTrasactionsByPeriod(period: StatsPeriod.day);

      expect(sut.selectedPeriod, StatsPeriod.day);
      expect(sut.transactions, isNotEmpty);
      expect(sut.valueSpots, isNotEmpty);
      expect(sut.minY, 0);
      expect(sut.minX, 0);
      expect(sut.maxY, 200);
      expect(sut.maxX, 23);
      expect(sut.interval, 4);
    });

    test('and the period is StatsPeriod.week', () async {
      when(() => mockTransactionRepository.getTransactionsByDateRange(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate')))
          .thenAnswer((_) async => DataResult.success(transactions));

      await sut.getTrasactionsByPeriod(period: StatsPeriod.week);

      expect(sut.selectedPeriod, StatsPeriod.week);
      expect(sut.transactions, isNotEmpty);
      expect(sut.valueSpots, isNotEmpty);
      expect(sut.minY, 0);
      expect(sut.minX, 0);
      expect(sut.maxY, 200);
      expect(sut.maxX, 6);
      expect(sut.interval, 1);
    });

    test('and the period is StatsPeriod.month', () async {
      when(() => mockTransactionRepository.getTransactionsByDateRange(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate')))
          .thenAnswer((_) async => DataResult.success(transactions));

      await sut.getTrasactionsByPeriod(period: StatsPeriod.month);

      expect(sut.selectedPeriod, StatsPeriod.month);
      expect(sut.transactions, isNotEmpty);
      expect(sut.valueSpots, isNotEmpty);
      expect(sut.minY, 0);
      expect(sut.minX, 0);
      expect(sut.maxY, 200);
      expect(sut.maxX, DateTime.now().weeksInMonth - 1);
      expect(sut.interval, 1);
    });

    test('and the period is StatsPeriod.year', () async {
      when(() => mockTransactionRepository.getTransactionsByDateRange(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate')))
          .thenAnswer((_) async => DataResult.success(transactions));

      await sut.getTrasactionsByPeriod(period: StatsPeriod.year);

      expect(sut.selectedPeriod, StatsPeriod.year);
      expect(sut.transactions, isNotEmpty);
      expect(sut.valueSpots, isNotEmpty);
      expect(sut.minY, 0);
      expect(sut.minX, 0);
      expect(sut.maxY, 200);
      expect(sut.maxX, 11);
      expect(sut.interval, 1);
    });
  });

  group('WHEN dayName is called', () {
    test('and the days index is 0', () {
      final result = sut.dayName(0);

      expect(result, 'Mon');
    });

    test('and the days index is 1', () {
      final result = sut.dayName(1);

      expect(result, 'Tue');
    });

    test('and the days index is 2', () {
      final result = sut.dayName(2);

      expect(result, 'Wed');
    });

    test('and the days index is 3', () {
      final result = sut.dayName(3);

      expect(result, 'Thu');
    });

    test('and the days index is 4', () {
      final result = sut.dayName(4);

      expect(result, 'Fri');
    });

    test('and the days index is 5', () {
      final result = sut.dayName(5);

      expect(result, 'Sat');
    });

    test('and the days index is 6', () {
      final result = sut.dayName(6);

      expect(result, 'Sun');
    });
  });

  group('WHEN monthName is called', () {
    test('and the month index is 0', () {
      final result = sut.monthName(0);

      expect(result, 'Jan');
    });

    test('and the month index is 1', () {
      final result = sut.monthName(1);

      expect(result, 'Feb');
    });

    test('and the month index is 2', () {
      final result = sut.monthName(2);

      expect(result, 'Mar');
    });

    test('and the month index is 3', () {
      final result = sut.monthName(3);

      expect(result, 'Apr');
    });

    test('and the month index is 4', () {
      final result = sut.monthName(4);

      expect(result, 'May');
    });

    test('and the month index is 5', () {
      final result = sut.monthName(5);

      expect(result, 'Jun');
    });

    test('and the month index is 6', () {
      final result = sut.monthName(6);

      expect(result, 'Jul');
    });

    test('and the month index is 7', () {
      final result = sut.monthName(7);

      expect(result, 'Aug');
    });

    test('and the month index is 8', () {
      final result = sut.monthName(8);

      expect(result, 'Sep');
    });

    test('and the month index is 9', () {
      final result = sut.monthName(9);

      expect(result, 'Oct');
    });

    test('and the month index is 10', () {
      final result = sut.monthName(10);

      expect(result, 'Nov');
    });

    test('and the month index is 11', () {
      final result = sut.monthName(11);

      expect(result, 'Dec');
    });
  });
}
