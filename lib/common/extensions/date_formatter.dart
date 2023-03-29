import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String get toText {
    if (day == DateTime.now().day) {
      return 'Today';
    }
    if (day == DateTime.now().subtract(const Duration(days: 1)).day) {
      return 'Yesterday';
    }
    return DateFormat('EEE, MMM d, ' 'yy').format(this);
  }
}
