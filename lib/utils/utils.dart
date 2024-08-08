import 'package:intl/intl.dart';

const int expireLogOut = 5;

class Utils {
  formatCurrency(value) {
    var result;
    if (value == '0.00' || value == '0' || value == "0.0") {
      return result = '0.00';
    }
    var formattedNumber =
        NumberFormat("#,###.00", "en_US").format(double.parse(value));
    result = formattedNumber.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}'");

    return result;
  }

  static String formatUTC8(String utcDateString) {
    // Parse the UTC date string into a DateTime object
    DateTime utcDate = DateTime.parse(utcDateString).toUtc();

    // Convert UTC DateTime to UTC+8
    DateTime utc8Date = utcDate.add(const Duration(hours: 8));

    // Format the DateTime object to a string with the desired format
    return DateFormat("yyyy-MM-dd HH:mm").format(utc8Date).toString();
  }
}
