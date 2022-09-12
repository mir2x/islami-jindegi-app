import 'package:intl/intl.dart';

String formatDate(date) {
  var inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

  var outputFormat = DateFormat('dd MMMM yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
