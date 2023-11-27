import 'package:intl/intl.dart';

class PriceHelper {
  static String _formatCurrency(double number, {bool useSymbol = true}) {
    final NumberFormat _fmt =
        NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = _fmt.format(number);
    String _format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return _format;
  }
}
