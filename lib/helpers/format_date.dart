import 'package:intl/intl.dart';

String formatDate(String date) {
  var inputDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(date);
  return DateFormat('dd MMMM yyyy').format(inputDate);
}
