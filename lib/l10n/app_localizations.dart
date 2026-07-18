import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @siteFullName.
  ///
  /// In en, this message translates to:
  /// **'Islami Jindegi'**
  String get siteFullName;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @article.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get article;

  /// No description provided for @malfuzat.
  ///
  /// In en, this message translates to:
  /// **'Malfuzat'**
  String get malfuzat;

  /// No description provided for @masail.
  ///
  /// In en, this message translates to:
  /// **'Masail'**
  String get masail;

  /// No description provided for @duaDurud.
  ///
  /// In en, this message translates to:
  /// **'Dua & Durud'**
  String get duaDurud;

  /// No description provided for @namazTime.
  ///
  /// In en, this message translates to:
  /// **'Namaz Time'**
  String get namazTime;

  /// No description provided for @bayans.
  ///
  /// In en, this message translates to:
  /// **'Bayans'**
  String get bayans;

  /// No description provided for @bayan.
  ///
  /// In en, this message translates to:
  /// **'Bayan'**
  String get bayan;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @madrasah.
  ///
  /// In en, this message translates to:
  /// **'Madrasah'**
  String get madrasah;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @qiblah.
  ///
  /// In en, this message translates to:
  /// **'Qiblah'**
  String get qiblah;

  /// No description provided for @mosques.
  ///
  /// In en, this message translates to:
  /// **'Mosques'**
  String get mosques;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @donation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get donation;

  /// No description provided for @importantMatters.
  ///
  /// In en, this message translates to:
  /// **'Important Matters'**
  String get importantMatters;

  /// No description provided for @newBooks.
  ///
  /// In en, this message translates to:
  /// **'New Books'**
  String get newBooks;

  /// No description provided for @newArticles.
  ///
  /// In en, this message translates to:
  /// **'New Articles'**
  String get newArticles;

  /// No description provided for @newBayans.
  ///
  /// In en, this message translates to:
  /// **'New Bayans'**
  String get newBayans;

  /// No description provided for @newMalfuzat.
  ///
  /// In en, this message translates to:
  /// **'New Malfuzat'**
  String get newMalfuzat;

  /// No description provided for @surah.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surah;

  /// No description provided for @para.
  ///
  /// In en, this message translates to:
  /// **'Para'**
  String get para;

  /// No description provided for @ayah.
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get ayah;

  /// No description provided for @tafseer.
  ///
  /// In en, this message translates to:
  /// **'Tafseer'**
  String get tafseer;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @tilawat.
  ///
  /// In en, this message translates to:
  /// **'Tilawat'**
  String get tilawat;

  /// No description provided for @ayahTranslations.
  ///
  /// In en, this message translates to:
  /// **'Ayah Translations'**
  String get ayahTranslations;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @qaris.
  ///
  /// In en, this message translates to:
  /// **'Qaris'**
  String get qaris;

  /// No description provided for @tafseerQitabs.
  ///
  /// In en, this message translates to:
  /// **'Tafseer Qitabs'**
  String get tafseerQitabs;

  /// No description provided for @range.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// No description provided for @makkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get makkah;

  /// No description provided for @madinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get madinah;

  /// No description provided for @makkahAndMadinah.
  ///
  /// In en, this message translates to:
  /// **'Makkah-Madinah'**
  String get makkahAndMadinah;

  /// No description provided for @selectQitab.
  ///
  /// In en, this message translates to:
  /// **'Select a Qitab'**
  String get selectQitab;

  /// No description provided for @pageBasedQuran.
  ///
  /// In en, this message translates to:
  /// **'Page Based Quran'**
  String get pageBasedQuran;

  /// No description provided for @quranTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get quranTitle;

  /// No description provided for @surahIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Surah Introduction'**
  String get surahIntroduction;

  /// No description provided for @savedAyahs.
  ///
  /// In en, this message translates to:
  /// **'Saved Ayahs'**
  String get savedAyahs;

  /// No description provided for @readTafseer.
  ///
  /// In en, this message translates to:
  /// **'Read Tafseer'**
  String get readTafseer;

  /// No description provided for @quranCatalogueEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Quran Translation & Tafseer'**
  String get quranCatalogueEyebrow;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @continueReadingDescription.
  ///
  /// In en, this message translates to:
  /// **'Resume from your last read position, or open the surah list to choose a new place.'**
  String get continueReadingDescription;

  /// No description provided for @mushafLibrary.
  ///
  /// In en, this message translates to:
  /// **'Mushaf Library'**
  String get mushafLibrary;

  /// No description provided for @mushafSubtitleImdadiaHafezi.
  ///
  /// In en, this message translates to:
  /// **'Imdadia Library hafezi layout'**
  String get mushafSubtitleImdadiaHafezi;

  /// No description provided for @mushafSubtitleHafezi.
  ///
  /// In en, this message translates to:
  /// **'Classic memorization-friendly layout'**
  String get mushafSubtitleHafezi;

  /// No description provided for @mushafSubtitleColorfulTajweed.
  ///
  /// In en, this message translates to:
  /// **'Color-guided pages for tajweed reading'**
  String get mushafSubtitleColorfulTajweed;

  /// No description provided for @mushafSubtitleMadani.
  ///
  /// In en, this message translates to:
  /// **'Uthmani Madani print edition'**
  String get mushafSubtitleMadani;

  /// No description provided for @mushafSubtitleNurani.
  ///
  /// In en, this message translates to:
  /// **'Beginner-friendly Nurani layout'**
  String get mushafSubtitleNurani;

  /// No description provided for @mushafSubtitleColorfulHafezi.
  ///
  /// In en, this message translates to:
  /// **'Colorful hafezi page layout'**
  String get mushafSubtitleColorfulHafezi;

  /// No description provided for @mushafDownloadLinkError.
  ///
  /// In en, this message translates to:
  /// **'There was a problem generating the download link. Please try again.'**
  String get mushafDownloadLinkError;

  /// No description provided for @mushafFilesMissingError.
  ///
  /// In en, this message translates to:
  /// **'Mushaf files were not found. Please download again.'**
  String get mushafFilesMissingError;

  /// No description provided for @saveAyah.
  ///
  /// In en, this message translates to:
  /// **'Save Ayah'**
  String get saveAyah;

  /// No description provided for @copyAyah.
  ///
  /// In en, this message translates to:
  /// **'Copy Ayah'**
  String get copyAyah;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @goToPage.
  ///
  /// In en, this message translates to:
  /// **'Go to Page'**
  String get goToPage;

  /// No description provided for @bismillah.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, Most Gracious, Most Merciful.'**
  String get bismillah;

  /// No description provided for @serialTilawat.
  ///
  /// In en, this message translates to:
  /// **'Serial Tilawat'**
  String get serialTilawat;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakers;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @audioDuration.
  ///
  /// In en, this message translates to:
  /// **'Audio Duration'**
  String get audioDuration;

  /// No description provided for @audioSize.
  ///
  /// In en, this message translates to:
  /// **'Audio Size'**
  String get audioSize;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get fileSize;

  /// No description provided for @authors.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get authors;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @authorsOrSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Authors/Speakers'**
  String get authorsOrSpeakers;

  /// No description provided for @contents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get contents;

  /// No description provided for @bookInfo.
  ///
  /// In en, this message translates to:
  /// **'Book Info'**
  String get bookInfo;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @publicationDate.
  ///
  /// In en, this message translates to:
  /// **'Publication Date'**
  String get publicationDate;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @tahajjudSehri.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud, Sehri Ends'**
  String get tahajjudSehri;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @ishraqChasht.
  ///
  /// In en, this message translates to:
  /// **'Ishraq, Chasht'**
  String get ishraqChasht;

  /// No description provided for @midday.
  ///
  /// In en, this message translates to:
  /// **'Midday'**
  String get midday;

  /// No description provided for @zuhr.
  ///
  /// In en, this message translates to:
  /// **'Zuhr'**
  String get zuhr;

  /// No description provided for @zuhrZawal.
  ///
  /// In en, this message translates to:
  /// **'Zuhr, Zawal'**
  String get zuhrZawal;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @maghribIftar.
  ///
  /// In en, this message translates to:
  /// **'Maghrib, Iftar'**
  String get maghribIftar;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @waqtStarts.
  ///
  /// In en, this message translates to:
  /// **'Waqt Starts'**
  String get waqtStarts;

  /// No description provided for @waqtEnds.
  ///
  /// In en, this message translates to:
  /// **'Waqt Ends'**
  String get waqtEnds;

  /// No description provided for @starts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get starts;

  /// No description provided for @ends.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get ends;

  /// No description provided for @fazail.
  ///
  /// In en, this message translates to:
  /// **'Fazail'**
  String get fazail;

  /// No description provided for @namazSettings.
  ///
  /// In en, this message translates to:
  /// **'Namaz Settings'**
  String get namazSettings;

  /// No description provided for @mazhab.
  ///
  /// In en, this message translates to:
  /// **'Mazhab'**
  String get mazhab;

  /// No description provided for @calcuationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calcuationMethod;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minute(s)'**
  String get minutes;

  /// No description provided for @minutesHint.
  ///
  /// In en, this message translates to:
  /// **'min: -60, max: 60'**
  String get minutesHint;

  /// No description provided for @hijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get hijri;

  /// No description provided for @muharrom.
  ///
  /// In en, this message translates to:
  /// **'Muharrom'**
  String get muharrom;

  /// No description provided for @safar.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get safar;

  /// No description provided for @rabiulAowal.
  ///
  /// In en, this message translates to:
  /// **'Rabiul Aowal'**
  String get rabiulAowal;

  /// No description provided for @rabiusSani.
  ///
  /// In en, this message translates to:
  /// **'Rabius Sani'**
  String get rabiusSani;

  /// No description provided for @jamadalUla.
  ///
  /// In en, this message translates to:
  /// **'Jumadal Ula'**
  String get jamadalUla;

  /// No description provided for @jamadalUkhra.
  ///
  /// In en, this message translates to:
  /// **'Jumadal Ukhra'**
  String get jamadalUkhra;

  /// No description provided for @rajab.
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get rajab;

  /// No description provided for @shaban.
  ///
  /// In en, this message translates to:
  /// **'Shaban'**
  String get shaban;

  /// No description provided for @ramajan.
  ///
  /// In en, this message translates to:
  /// **'Ramajan'**
  String get ramajan;

  /// No description provided for @shauwal.
  ///
  /// In en, this message translates to:
  /// **'Shauwal'**
  String get shauwal;

  /// No description provided for @jilqod.
  ///
  /// In en, this message translates to:
  /// **'Jilqod'**
  String get jilqod;

  /// No description provided for @jilhajj.
  ///
  /// In en, this message translates to:
  /// **'Jilhajj'**
  String get jilhajj;

  /// No description provided for @hijriDateAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Hijri Date Adjustment'**
  String get hijriDateAdjustment;

  /// No description provided for @daylightSaving.
  ///
  /// In en, this message translates to:
  /// **'Daylight Saving'**
  String get daylightSaving;

  /// No description provided for @onlyUsedToCalculatePrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Only used to calculate prayer times'**
  String get onlyUsedToCalculatePrayerTimes;

  /// No description provided for @banglaFont.
  ///
  /// In en, this message translates to:
  /// **'Bangla Font'**
  String get banglaFont;

  /// No description provided for @arabicFont.
  ///
  /// In en, this message translates to:
  /// **'Arabic Font'**
  String get arabicFont;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @mosqueBackground.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get mosqueBackground;

  /// No description provided for @noBackground.
  ///
  /// In en, this message translates to:
  /// **'No Background'**
  String get noBackground;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @setLocation.
  ///
  /// In en, this message translates to:
  /// **'Set Location'**
  String get setLocation;

  /// No description provided for @waysOfSettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Location can be set by one of two following ways:'**
  String get waysOfSettingLocation;

  /// No description provided for @manualLocation.
  ///
  /// In en, this message translates to:
  /// **'1. Manual Location'**
  String get manualLocation;

  /// No description provided for @withGeolocation.
  ///
  /// In en, this message translates to:
  /// **'2. With Geo-location'**
  String get withGeolocation;

  /// No description provided for @giveGeolocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Give Geo-location Permission'**
  String get giveGeolocationPermission;

  /// No description provided for @geolocationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Geo-location Enabled'**
  String get geolocationEnabled;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @geolocationBenefits.
  ///
  /// In en, this message translates to:
  /// **'Location will automatically update as you move'**
  String get geolocationBenefits;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select a Country'**
  String get selectCountry;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search for a country'**
  String get searchCountry;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get searchCity;

  /// No description provided for @qiblahInstruction.
  ///
  /// In en, this message translates to:
  /// **'Set the device horizontally to get the best result.'**
  String get qiblahInstruction;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear this filter'**
  String get clearFilter;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchInQuran.
  ///
  /// In en, this message translates to:
  /// **'Search in Quran'**
  String get searchInQuran;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get bangla;

  /// No description provided for @searchInArabic.
  ///
  /// In en, this message translates to:
  /// **'Search in Arabic'**
  String get searchInArabic;

  /// No description provided for @searchInBangla.
  ///
  /// In en, this message translates to:
  /// **'Search in Bangla'**
  String get searchInBangla;

  /// No description provided for @quranSearchNoMatch.
  ///
  /// In en, this message translates to:
  /// **'There is no ayah which matches your query.'**
  String get quranSearchNoMatch;

  /// No description provided for @quranSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a word or sentence in arabic'**
  String get quranSearchPlaceholder;

  /// No description provided for @quranSearchErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Search text cannot exceed 100 letters'**
  String get quranSearchErrorMessage;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @anyTime.
  ///
  /// In en, this message translates to:
  /// **'Any Time'**
  String get anyTime;

  /// No description provided for @pastWeek.
  ///
  /// In en, this message translates to:
  /// **'Past Week'**
  String get pastWeek;

  /// No description provided for @pastMonth.
  ///
  /// In en, this message translates to:
  /// **'Past Month'**
  String get pastMonth;

  /// No description provided for @pastYear.
  ///
  /// In en, this message translates to:
  /// **'Past Year'**
  String get pastYear;

  /// No description provided for @pastFiveYears.
  ///
  /// In en, this message translates to:
  /// **'Past 5 Years'**
  String get pastFiveYears;

  /// No description provided for @pastTenYears.
  ///
  /// In en, this message translates to:
  /// **'Past 10 Years'**
  String get pastTenYears;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Change Date'**
  String get customDate;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dateFrom.
  ///
  /// In en, this message translates to:
  /// **'Date From'**
  String get dateFrom;

  /// No description provided for @dateTo.
  ///
  /// In en, this message translates to:
  /// **'Date To'**
  String get dateTo;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted'**
  String get bookmarkDeleted;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask Question'**
  String get askQuestion;

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get askAQuestion;

  /// No description provided for @emailAppHint.
  ///
  /// In en, this message translates to:
  /// **'It will open your default Email app'**
  String get emailAppHint;

  /// No description provided for @questionRequired.
  ///
  /// In en, this message translates to:
  /// **'Question (required)'**
  String get questionRequired;

  /// No description provided for @yourNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Your Name (optional)'**
  String get yourNameOptional;

  /// No description provided for @yourContactOptional.
  ///
  /// In en, this message translates to:
  /// **'Contact No (optional)'**
  String get yourContactOptional;

  /// No description provided for @newsAndUpdates.
  ///
  /// In en, this message translates to:
  /// **'News & Updates'**
  String get newsAndUpdates;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @downloadedBooks.
  ///
  /// In en, this message translates to:
  /// **'Downloaded Books'**
  String get downloadedBooks;

  /// No description provided for @downloadedBayans.
  ///
  /// In en, this message translates to:
  /// **'Downloaded Bayans'**
  String get downloadedBayans;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @pdfFiles.
  ///
  /// In en, this message translates to:
  /// **'PDF Files'**
  String get pdfFiles;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @fileDelete.
  ///
  /// In en, this message translates to:
  /// **'File Delete'**
  String get fileDelete;

  /// No description provided for @doYouWantToDeleteFile.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the file from your store?'**
  String get doYouWantToDeleteFile;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noContent;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @dontDisplay.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Display'**
  String get dontDisplay;

  /// No description provided for @dhaka.
  ///
  /// In en, this message translates to:
  /// **'Dhaka'**
  String get dhaka;

  /// No description provided for @bangladesh.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get bangladesh;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareThisApp.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get shareThisApp;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateThisApp;

  /// No description provided for @androidAppLink.
  ///
  /// In en, this message translates to:
  /// **'Android App Link'**
  String get androidAppLink;

  /// No description provided for @iphoneAppLink.
  ///
  /// In en, this message translates to:
  /// **'iPhone App Link'**
  String get iphoneAppLink;

  /// No description provided for @websiteLink.
  ///
  /// In en, this message translates to:
  /// **'Website Link'**
  String get websiteLink;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @deleteFile.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get deleteFile;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open File'**
  String get openFile;

  /// No description provided for @switchMode.
  ///
  /// In en, this message translates to:
  /// **'Switch Mode'**
  String get switchMode;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get errorTitle;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFoundTitle;

  /// No description provided for @pageNotFoundMsg.
  ///
  /// In en, this message translates to:
  /// **'We cannot seem to find the page you are looking for.'**
  String get pageNotFoundMsg;

  /// No description provided for @noItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsTitle;

  /// No description provided for @noItemsMsg.
  ///
  /// In en, this message translates to:
  /// **'The list is currently empty.\nIf you are using any filter, please try with other filter options.'**
  String get noItemsMsg;

  /// No description provided for @noAyahTranslation.
  ///
  /// In en, this message translates to:
  /// **'No translation found for this ayah'**
  String get noAyahTranslation;

  /// No description provided for @applicationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get applicationErrorTitle;

  /// No description provided for @applicationErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'The application has encountered an unknown error.\n Please try again later.'**
  String get applicationErrorMsg;

  /// No description provided for @newPageErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Tap to try again.'**
  String get newPageErrorTitle;

  /// No description provided for @downloadErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'There has been a problem while downloading the file. Please check your network connection and try again.'**
  String get downloadErrorMsg;

  /// No description provided for @documentLoadErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'There has been a problem loading the document. Please try again.'**
  String get documentLoadErrorMsg;

  /// No description provided for @connectToInternetMsg.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the Internet'**
  String get connectToInternetMsg;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @prayerAlarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get prayerAlarm;

  /// No description provided for @upcomingPrayer.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Prayer'**
  String get upcomingPrayer;

  /// No description provided for @nextPrayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayerLabel;

  /// No description provided for @currentPrayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentPrayerLabel;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextLabel;

  /// No description provided for @endsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get endsLabel;

  /// No description provided for @startsLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get startsLabel;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// No description provided for @sahurEnds.
  ///
  /// In en, this message translates to:
  /// **'Sahur Ends'**
  String get sahurEnds;

  /// No description provided for @iftar.
  ///
  /// In en, this message translates to:
  /// **'Iftar'**
  String get iftar;

  /// No description provided for @dailyPrayers.
  ///
  /// In en, this message translates to:
  /// **'Daily Prayers'**
  String get dailyPrayers;

  /// No description provided for @autoAdhanOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-Adhan On'**
  String get autoAdhanOn;

  /// No description provided for @autoAdhanOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-Adhan Off'**
  String get autoAdhanOff;

  /// No description provided for @forbiddenTimes.
  ///
  /// In en, this message translates to:
  /// **'Forbidden Times'**
  String get forbiddenTimes;

  /// No description provided for @knowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get knowledge;

  /// No description provided for @knowledgeQuote.
  ///
  /// In en, this message translates to:
  /// **'\"The best of people are those who are most beneficial to others.\"'**
  String get knowledgeQuote;

  /// No description provided for @endsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends at'**
  String get endsAt;

  /// No description provided for @inHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {hours} hr {minutes} min'**
  String inHoursMinutes(String hours, String minutes);

  /// No description provided for @inMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes} min'**
  String inMinutes(String minutes);

  /// No description provided for @alarmEnabled.
  ///
  /// In en, this message translates to:
  /// **'Alarm enabled'**
  String get alarmEnabled;

  /// No description provided for @alarmDisabled.
  ///
  /// In en, this message translates to:
  /// **'Alarm disabled'**
  String get alarmDisabled;

  /// No description provided for @alarmSettings.
  ///
  /// In en, this message translates to:
  /// **'Alarm Settings'**
  String get alarmSettings;

  /// No description provided for @beforeWaqt.
  ///
  /// In en, this message translates to:
  /// **'Before waqt'**
  String get beforeWaqt;

  /// No description provided for @afterWaqt.
  ///
  /// In en, this message translates to:
  /// **'After waqt'**
  String get afterWaqt;

  /// No description provided for @prayerTimeAlert.
  ///
  /// In en, this message translates to:
  /// **'Time for prayer'**
  String get prayerTimeAlert;

  /// No description provided for @customSound.
  ///
  /// In en, this message translates to:
  /// **'Custom Sound'**
  String get customSound;

  /// No description provided for @defaultSound.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultSound;

  /// No description provided for @stopAlarm.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopAlarm;

  /// No description provided for @allAlarms.
  ///
  /// In en, this message translates to:
  /// **'All Alarms'**
  String get allAlarms;

  /// No description provided for @noOffset.
  ///
  /// In en, this message translates to:
  /// **'At waqt time'**
  String get noOffset;

  /// No description provided for @azanSound.
  ///
  /// In en, this message translates to:
  /// **'Azan Sound'**
  String get azanSound;

  /// No description provided for @repeatDays.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatDays;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyday;

  /// No description provided for @recentlyRead.
  ///
  /// In en, this message translates to:
  /// **'Recently Read'**
  String get recentlyRead;

  /// No description provided for @recentlyListened.
  ///
  /// In en, this message translates to:
  /// **'Recently Listened'**
  String get recentlyListened;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
