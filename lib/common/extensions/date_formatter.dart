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

  String get formatISOTime {
    var duration = timeZoneOffset;
    if (duration.isNegative) {
      return ("${toIso8601String().replaceAll('Z', '-')}${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    } else {
      return ("${toIso8601String().replaceAll('Z', '+')}${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }
  }

  /// Returns the date in the format yyyy-MM-dd
  String get yMd {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
