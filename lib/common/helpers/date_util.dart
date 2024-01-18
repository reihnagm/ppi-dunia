import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ppidunia/localization/language_constraints.dart';

class DateHelper {
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static String formatDateTime(String val) {
    return val.contains("hours ago")
        ? "${val.split(' ')[0]} ${getTranslated("HOURS_AGO")}"
        : val.contains("minutes ago")
            ? "${val.split('')[0]}${val.split('')[1]} ${getTranslated("MINUTES_AGO")}"
            : val.contains("years ago")
                ? "${val.split('')[0]} ${getTranslated("YEARS_AGO")}"
                : val.contains("an hour ago")
                    ? getTranslated("AN_HOUR_AGO")
                    : val.contains("days ago")
                        ? "${val.split(' ')[0]} ${getTranslated("DAYS_AGO")}"
                        : val.contains("seconds ago")
                            ? getTranslated("SECONDS_AGO")
                            : val.contains("a minute ago")
                                ? getTranslated("A_MINUTE_AGO")
                                : val.contains("a day ago")
                                    ? getTranslated("A_DAY_AGO")
                                    : val;
  }
}
