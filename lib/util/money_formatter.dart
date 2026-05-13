import 'package:intl/intl.dart';

class MoneyFormatter {
  static String brl(double value) {
    return NumberFormat("R\$ ###,##0.00", "pt_BR").format(value);
  }
}
