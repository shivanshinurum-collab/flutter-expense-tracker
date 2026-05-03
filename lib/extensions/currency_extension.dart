import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/modules/settings/settings_controller.dart';

extension CurrencyParsing on double {
  String parseCurrency() {
    final symbol = Get.find<SettingsController>().currencySymbol.value;
    final formatter = NumberFormat('#,##0.00');
    return '$symbol${formatter.format(this)}';
  }
}
