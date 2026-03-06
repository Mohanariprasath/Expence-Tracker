import 'package:intl/intl.dart';

class CurrencyUtils {
  static const String symbol = '₹';

  static String format(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
