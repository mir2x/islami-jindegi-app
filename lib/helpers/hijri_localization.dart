import 'package:native_app/core/utils/bengali_digit_extension.dart';

const List<String> hijriMonthsBengali = [
  'মুহাররম',
  'সফর',
  'রবিউল আউয়াল',
  'রবিউস সানি',
  'জুমাদাল উলা',
  'জুমাদাল উখরা',
  'রজব',
  'শাবান',
  'রমজান',
  'শাওয়াল',
  'জিলকদ',
  'জিলহজ',
];

const List<String> hijriMonthsEnglish = [
  'Muharram',
  'Safar',
  'Rabi al-Awwal',
  'Rabi al-Thani',
  'Jumada al-Ula',
  'Jumada al-Akhirah',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhu al-Qi'dah",
  'Dhu al-Hijjah',
];

// Bengali weekday labels (short), index 0 = Sunday
const List<String> weekdaysBengaliShort = [
  'রবি',
  'সোম',
  'মঙ্গল',
  'বুধ',
  'বৃহ',
  'শুক্র',
  'শনি',
];

String hijriMonthYearBengali(int month, int year) {
  final monthName = hijriMonthsBengali[month - 1];
  final yearBn = year.toBengaliDigit();
  return '$monthName $yearBn';
}

String hijriMonthYearEnglish(int month, int year) {
  return '${hijriMonthsEnglish[month - 1]} $year';
}
