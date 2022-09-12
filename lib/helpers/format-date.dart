import 'package:intl/intl.dart';

String formatDate(date) {
  var inputDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(date);
  return DateFormat('dd MMMM yyyy').format(inputDate);
}
