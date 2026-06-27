import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(
    double amount, {
    String symbol = 'Rp',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '$symbol ',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String symbol = 'Rp'}) {
    if (amount.abs() >= 1_000_000) {
      final value = amount / 1_000_000;
      final formatted = value == value.truncateToDouble()
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1).replaceAll('.', ',');
      return '$symbol $formatted Jt';
    } else if (amount.abs() >= 1_000) {
      final value = amount / 1_000;
      final formatted = value == value.truncateToDouble()
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1).replaceAll('.', ',');
      return '$symbol $formatted Rb';
    } else {
      return format(amount, symbol: symbol);
    }
  }
}
