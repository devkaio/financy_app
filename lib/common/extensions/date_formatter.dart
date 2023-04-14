import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String get toText {
    if (isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Today';
    }
    if (isAfter(DateTime.now().subtract(const Duration(days: 2))) &&
        isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }

    return DateFormat('EEE, MMM d, ' 'yy').format(this);
  }
}
