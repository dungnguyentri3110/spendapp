import 'package:spendapp/utils/global.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(
    DateTime dateTime, {
    String template = 'dd/MM/yyyy',
  }) {
    final dateFormat = DateFormat(template, GlobalApp.instance!.locale);
    return dateFormat.format(dateTime);
  }
}
