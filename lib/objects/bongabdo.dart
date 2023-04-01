final banglaMonths = [
  'বৈশাখ',
  'জ্যৈষ্ঠ',
  'আষাঢ়',
  'শ্রাবণ',
  'ভাদ্র',
  'আশ্বিন',
  'কার্তিক',
  'অগ্রহায়ণ',
  'পৌষ',
  'মাঘ',
  'ফাল্গুন',
  'চৈত্র'
];

final Map<int, String> banglaWeekDays = {
  7: 'রবিবার',
  1: 'সোমবার',
  2: 'মঙ্গলবার',
  3: 'বুধবার',
  4: 'বৃহস্পতিবার',
  5: 'শুক্রবার',
  6: 'শনিবার'
};

final banglaSeasons = ['গ্রীষ্ম', 'বর্ষা', 'শরৎ', 'হেমন্ত', 'শীত', 'বসন্ত'];

final totalDaysInMonthOld = [31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30, 30];
final totalDaysInMonthNew = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30];

bool isLeapYear(int year) =>
    ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);

String translateNumbersToBangla(String number) {
  number = number.replaceAll('0', '০');
  number = number.replaceAll('1', '১');
  number = number.replaceAll('2', '২');
  number = number.replaceAll('3', '৩');
  number = number.replaceAll('4', '৪');
  number = number.replaceAll('5', '৫');
  number = number.replaceAll('6', '৬');
  number = number.replaceAll('7', '৭');
  number = number.replaceAll('8', '৮');
  number = number.replaceAll('9', '৯');
  return number;
}

class Bongabdo {
  var bDay;
  var bMonth;
  var bYear;
  var bSeason;
  var bWeekDay;
  var version;

  Bongabdo.addMonth(int year, int month) {
    bYear = month % 12 == 0 ? year - 1 : year;
    bMonth = month % 12 == 0 ? 12 : month % 12;
    bDay = 1;
  }

  Bongabdo.fromDate(DateTime date, [this.version]) {
    toBanglaDate(date.year, date.month, date.day);
  }

  Bongabdo.now([this.version]) {
    var today = DateTime.now();
    toBanglaDate(today.year, today.month, today.day);
  }

  bDate(year, month, day, weekday, season) {
    bYear = year;
    bMonth = month;
    bDay = day;
    bWeekDay = weekday;
    bSeason = season;
  }

  List<int> toList() => [bYear, bMonth, bDay];

  String fullDate() =>
      '$bDay, $bMonth, $bYear বঙ্গাব্দ, $bSeason কাল, রোজ $bWeekDay';

  bool isnew() => version == 'new';

  toBanglaDate(gYear, gMonth, gDay) {
    var totalDaysInMonth = isnew() ? totalDaysInMonthNew : totalDaysInMonthOld;

    isLeapYear(gYear) && isnew()
        ? totalDaysInMonth[10] = 29
        : totalDaysInMonth[10] = 31;

    /* if (isLeapYear(gYear)){
      totalDaysInMonth[10] = 31;
    } */

    int banglaYear =
        (gMonth < 4 || (gMonth == 4 && gDay < 14)) ? gYear - 594 : gYear - 593;

    int epochYear =
        (gMonth < 4 || (gMonth == 4 && gDay < 14)) ? gYear - 1 : gYear;

    var difference = (DateTime.utc(gYear, gMonth, gDay)
            .difference(DateTime.utc(epochYear, 04, 13)))
        .inDays
        .floor();

    var banglaMonthIndex = 0;

    for (var i = 0; i < banglaMonths.length; i++) {
      if (difference <= totalDaysInMonth[i]) {
        banglaMonthIndex = i;
        break;
      }
      difference -= totalDaysInMonth[i];
    }

    var banglaDate = difference;

    var banglaSeason = banglaSeasons[(banglaMonthIndex / 2).floor()];

    var banglaWeekDay = DateTime(gYear, gMonth, gDay).weekday;

    return bDate(
      translateNumbersToBangla(banglaYear.toString()),
      banglaMonths[banglaMonthIndex],
      translateNumbersToBangla(banglaDate.toString()),
      banglaWeekDays[banglaWeekDay],
      banglaSeason,
    );
  }
}
