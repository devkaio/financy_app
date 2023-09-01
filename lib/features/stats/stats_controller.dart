import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/date_formatter.dart';
import '../../common/models/models.dart';
import '../../repositories/repositories.dart';
import 'stats_state.dart';

enum StatsPeriod { day, week, month, year }

class StatsController extends ChangeNotifier {
  StatsController({
    required TransactionRepository transactionRepository,
  }) : _transactionRepository = transactionRepository;

  final TransactionRepository _transactionRepository;

  StatsState _state = StatsStateInitial();

  StatsState get state => _state;

  void _changeState(StatsState newState) {
    _state = newState;
    notifyListeners();
  }

  List<StatsPeriod> get periods => StatsPeriod.values;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  List<FlSpot> _valueSpots = [];
  List<FlSpot> get valueSpots => _valueSpots;

  /// Used to set chart interval by [selectedPeriod]
  double get interval {
    switch (selectedPeriod) {
      case StatsPeriod.day:
        return 4;
      case StatsPeriod.week:
        return 1;
      case StatsPeriod.month:
        return 1;
      case StatsPeriod.year:
        return 1;
    }
  }

  double get minY =>
      _valueSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
  double get maxY =>
      _valueSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  double get minX =>
      _valueSpots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
  double get maxX =>
      _valueSpots.map((e) => e.x).reduce((a, b) => a > b ? a : b);

  bool _sorted = false;
  bool get sorted => _sorted;
  void sortTransactions() {
    _changeState(StatsStateLoading());
    _sorted = !_sorted;
    if (_sorted) {
      _transactions.sort((a, b) => a.value.compareTo(b.value));
    } else {
      _transactions.sort((a, b) => b.value.compareTo(a.value));
    }
    _changeState(StatsStateSuccess());
  }

  StatsPeriod _selectedPeriod = StatsPeriod.month;
  StatsPeriod get selectedPeriod => _selectedPeriod;
  Future<void> getTrasactionsByPeriod({StatsPeriod? period}) async {
    _selectedPeriod = period ?? selectedPeriod;
    _changeState(StatsStateLoading());

    DateTime start;
    DateTime end;
    DateTime currentDate = DateTime.now();

    switch (selectedPeriod) {
      case StatsPeriod.day:
        start = DateTime(
            currentDate.year, currentDate.month, currentDate.day, 0, 0, 0);
        end = DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
        break;
      case StatsPeriod.week:
        start = currentDate.subtract(Duration(days: currentDate.weekday - 1));
        start = DateTime(start.year, start.month, start.day, 0, 0, 0);
        end = start
            .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case StatsPeriod.month:
        start = DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0);
        end = DateTime(currentDate.year, currentDate.month + 1, 0, 23, 59, 59);
        break;
      case StatsPeriod.year:
        start = DateTime(currentDate.year, 1, 1, 0, 0, 0);
        end = DateTime(currentDate.year, 12, 31, 23, 59, 59);
        break;
    }

    final result = await _transactionRepository.getTransactionsByDateRange(
      startDate: start,
      endDate: end,
    );
    result.fold(
      (error) => _changeState(StatsStateError()),
      (data) {
        _transactions = data;

        _getValueSpots();

        _changeState(StatsStateSuccess());
      },
    );
  }

  String dayName(double day) {
    switch (day) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }

  String monthName(double month) {
    switch (month) {
      case 0:
        return 'Jan';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Apr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Aug';
      case 8:
        return 'Sep';
      case 9:
        return 'Oct';
      case 10:
        return 'Nov';
      case 11:
        return 'Dec';
      default:
        return '';
    }
  }

  void _getValueSpots() {
    int groupingCount;
    bool Function(int, TransactionModel) groupingFunction;

    switch (selectedPeriod) {
      case StatsPeriod.day:
        groupingCount = hoursInDay;
        groupingFunction = _groupByHour;
        break;
      case StatsPeriod.week:
        groupingCount = daysInWeek;
        groupingFunction = _groupByDayOfWeek;
        break;
      case StatsPeriod.month:
        groupingCount = weeksInMonth;
        groupingFunction = _groupByWeekOfMonth;
        break;
      case StatsPeriod.year:
        groupingCount = monthsInYear;
        groupingFunction = _groupByMonth;
        break;
    }

    _generateTransactionsByGrouping(groupingCount, groupingFunction);
  }

  void _generateTransactionsByGrouping(
    int groupingCount,
    bool Function(int, TransactionModel) groupingFunction,
  ) {
    final spots = <FlSpot>[];
    for (int i = 0; i < groupingCount; i++) {
      final List<TransactionModel> transactionsByGroup =
          transactions.where((t) => groupingFunction(i, t)).toList();

      final double totalAmount = transactionsByGroup.fold(
        0.0,
        (previous, transaction) => previous + transaction.value,
      );

      spots.add(FlSpot(i.toDouble(), totalAmount));
    }
    _valueSpots = spots;
  }

  bool _groupByHour(
    int i,
    TransactionModel t,
  ) {
    final transactionDate = DateTime.fromMillisecondsSinceEpoch(t.date);
    return transactionDate.hour == i &&
        transactionDate.day == DateTime.now().day;
  }

  bool _groupByDayOfWeek(
    int i,
    TransactionModel t,
  ) {
    final transactionDate = DateTime.fromMillisecondsSinceEpoch(t.date);
    return transactionDate.weekday == i + 1;
  }

  bool _groupByWeekOfMonth(
    int i,
    TransactionModel t,
  ) {
    final transactionDate = DateTime.fromMillisecondsSinceEpoch(t.date);
    return transactionDate.week == i + 1;
  }

  bool _groupByMonth(
    int i,
    TransactionModel t,
  ) {
    final transactionDate = DateTime.fromMillisecondsSinceEpoch(t.date);
    return transactionDate.month == i + 1 &&
        transactionDate.year == DateTime.now().year;
  }
}
