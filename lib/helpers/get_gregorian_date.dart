import 'package:intl/intl.dart';

String getGregorianDate(String currentLang, DateTime? currentDate) {
  final DateTime today = currentDate ?? DateTime.now();
  return DateFormat('EEEE, dd MMMM, yyyy', currentLang).format(today);
}
