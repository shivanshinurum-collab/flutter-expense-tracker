import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

final formatter = NumberFormat.compactSimpleCurrency(
    locale: kIsWeb ? 'en_IN' : null, decimalDigits: 2);

extension CurrencyParsing on double {
  String parseCurrency() {
    return formatter.format(this);
  }
}

String getCurrencySymbol() {
  return formatter.currencySymbol;
}


