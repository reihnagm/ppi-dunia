import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateHelper {
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }
}
