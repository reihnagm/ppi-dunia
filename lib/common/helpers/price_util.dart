import 'package:intl/intl.dart';

class PriceHelper {
  static String formatCurrency(double number, {bool useSymbol = true}) {
    final NumberFormat fmt =
        NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = fmt.format(number);
    String format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return format;
  }
}
