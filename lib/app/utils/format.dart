import 'package:intl/intl.dart';

class Format {
  static String numberStr(double? number, [bool simple = false]) {
    return number != null ?
      (simple ? number.toString().replaceAll('.', ',') : NumberFormat("#,##0.00", "ru_RU").format(number)) :
      '';
  }

  static String dateStr(DateTime? date) {
    return date != null ? DateFormat.yMd('ru').format(date) : '';
  }

  static String dateTimeStr(DateTime? dateTime) {
    return dateTime != null ? DateFormat.yMMMd('ru').add_jm().format(dateTime) : '';
  }

  static String timeStr(DateTime? dateTime) {
    return dateTime != null ? DateFormat.Hm('ru').format(dateTime) : '';
  }
}
