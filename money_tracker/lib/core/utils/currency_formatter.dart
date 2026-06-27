import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String currentCode = 'IDR';
  static String currentSymbol = 'Rp';

  static final Map<String, (String, int)> currencyData = {
    'IDR': ('Rp', 0),
    'USD': ('\$', 2),
    'EUR': ('€', 2),
    'SGD': ('S\$', 2),
    'MYR': ('RM', 2),
    'GBP': ('£', 2),
    'JPY': ('¥', 0),
  };

  static void setCurrency(String code) {
    currentCode = code;
    if (currencyData.containsKey(code)) {
      currentSymbol = currencyData[code]!.$1;
    } else {
      currentSymbol = code;
    }
  }

  static String format(
    double amount, {
    String? symbol,
    int? decimalDigits,
  }) {
    final sym = symbol ?? currentSymbol;
    final digits = decimalDigits ?? (currencyData[currentCode]?.$2 ?? 0);
    final formatter = NumberFormat.currency(
      locale: currentCode == 'IDR' ? 'id_ID' : 'en_US',
      symbol: '$sym ',
      decimalDigits: digits,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {String? symbol}) {
    final sym = symbol ?? currentSymbol;
    if (currentCode == 'IDR') {
      if (amount.abs() >= 1_000_000) {
        final value = amount / 1_000_000;
        final formatted = value == value.truncateToDouble()
            ? value.toStringAsFixed(0)
            : value.toStringAsFixed(1).replaceAll('.', ',');
        return '$sym $formatted Jt';
      } else if (amount.abs() >= 1_000) {
        final value = amount / 1_000;
        final formatted = value == value.truncateToDouble()
            ? value.toStringAsFixed(0)
            : value.toStringAsFixed(1).replaceAll('.', ',');
        return '$sym $formatted Rb';
      }
    } else {
      if (amount.abs() >= 1_000_000) {
        return '$sym ${(amount / 1_000_000).toStringAsFixed(1)}M';
      } else if (amount.abs() >= 1_000) {
        return '$sym ${(amount / 1_000).toStringAsFixed(1)}K';
      }
    }
    return format(amount, symbol: sym);
  }
}
