import 'package:intl/intl.dart';

String formatDate(String date) {
  var onlyDate = date.split('T').first.split(' ').first;
  var inputDate = DateFormat('yyyy-MM-dd').parse(onlyDate);
  return DateFormat('dd MMMM yyyy').format(inputDate);
}
