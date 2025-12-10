const List<String> suraNames = [
  'আল-ফাতিহা',
  'আল-বাকারা',
  'আল-ইমরান',
  'আন-নিসা',
  'আল-মায়েদাহ',
  'আল-আনআম',
  'আল-আরাফ',
  'আল-আনফাল',
  'আত-তাওবাহ',
  'ইউনুস',
  'হুদ',
  'ইউসুফ',
  'আর-রাদ',
  'ইবরাহিম',
  'আল-হিজর',
  'আন-নাহল',
  'আল-ইসরা',
  'আল-কাহফ',
  'মারইয়াম',
  'ত্বা-হা',
  'আল-আম্বিয়া',
  'আল-হাজ্জ',
  'আল-মুমিনুন',
  'আন-নুর',
  'আল-ফুরকান',
  'আশ-শুআরা',
  'আন-নামল',
  'আল-কাসাস',
  'আল-আনকাবুত',
  'আর-রুম',
  'লুকমান',
  'আস-সাজদাহ',
  'আল-আহযাব',
  'সাবা',
  'ফাতির',
  'ইয়া-সীন',
  'আস-সাফফাত',
  'সা-দ',
  'আয-যুমার',
  'গাফির',
  'ফুসসিলাত',
  'আশ-শূরা',
  'আয-যুখরুফ',
  'আদ-দুখান',
  'আল-জাছিয়াহ',
  'আল-আহকাফ',
  'মুহাম্মাদ',
  'আল-ফাতহ',
  'আল-হুজুরাত',
  'ক্বাফ',
  'আয-যারিয়াত',
  'আত-তূর',
  'আন-নাজম',
  'আল-ক্বামার',
  'আর-রহমান',
  'আল-ওয়াকিআ',
  'আল-হাদীদ',
  'আল-মুজাদিলা',
  'আল-হাশর',
  'আল-মুমতাহিনাহ',
  'আস-সাফ',
  'আল-জুমুআ',
  'আল-মুনাফিকুন',
  'আত-তাগাবুন',
  'আত-ত্বালাক্ব',
  'আত-তাহরীম',
  'আল-মুলক',
  'আল-ক্বালাম',
  'আল-হাক্কাহ',
  'আল-মাআরিজ',
  'নূহ',
  'আল-জিন',
  'আল-মুযযাম্মিল',
  'আল-মুদ্দাসসির',
  'আল-ক্বিয়ামাহ',
  'আল-ইনসান',
  'আল-মুরসালাত',
  'আন-নাবা',
  'আন-নাযিয়াত',
  'আবাসা',
  'আত-তাকভীর',
  'আল-ইনফিতার',
  'আল-মুতাফফিফীন',
  'আল-ইনশিক্বাক্ব',
  'আল-বুরুজ',
  'আত-তারিক্ব',
  'আল-আলা',
  'আল-গাশিয়াহ',
  'আল-ফাজর',
  'আল-বালাদ',
  'আশ-শামস',
  'আল-লাইল',
  'আদ-দুহা',
  'আল-ইনশিরাহ',
  'আত-তীন',
  'আল-আলাক্ব',
  'আল-ক্বদর',
  'আল-বাইয়্যিনাহ',
  'আয-যালযালাহ',
  'আল-আদিয়াত',
  'আল-ক্বারিআহ',
  'আত-তাকাছুর',
  'আল-আসর',
  'আল-হুমাযাহ',
  'আল-ফীল',
  'কুরাইশ',
  'আল-মাউন',
  'আল-কাওসার',
  'আল-কাফিরুন',
  'আন-নাসর',
  'আল-মাসাদ',
  'আল-ইখলাস',
  'আল-ফালাক্ব',
  'আন-নাস',
];

/// Surah metadata: type (true = Madani, false = Makki) and total ayat count
class SurahInfo {
  final bool isMadani;
  final int ayatCount;

  const SurahInfo({required this.isMadani, required this.ayatCount});

  String get typeLabel => isMadani ? 'মাদানী' : 'মাক্কী';
}

const List<SurahInfo> surahInfoList = [
  SurahInfo(isMadani: false, ayatCount: 7), // 1. Al-Fatiha
  SurahInfo(isMadani: true, ayatCount: 286), // 2. Al-Baqarah
  SurahInfo(isMadani: true, ayatCount: 200), // 3. Al-Imran
  SurahInfo(isMadani: true, ayatCount: 176), // 4. An-Nisa
  SurahInfo(isMadani: true, ayatCount: 120), // 5. Al-Ma'idah
  SurahInfo(isMadani: false, ayatCount: 165), // 6. Al-An'am
  SurahInfo(isMadani: false, ayatCount: 206), // 7. Al-A'raf
  SurahInfo(isMadani: true, ayatCount: 75), // 8. Al-Anfal
  SurahInfo(isMadani: true, ayatCount: 129), // 9. At-Tawbah
  SurahInfo(isMadani: false, ayatCount: 109), // 10. Yunus
  SurahInfo(isMadani: false, ayatCount: 123), // 11. Hud
  SurahInfo(isMadani: false, ayatCount: 111), // 12. Yusuf
  SurahInfo(isMadani: true, ayatCount: 43), // 13. Ar-Ra'd
  SurahInfo(isMadani: false, ayatCount: 52), // 14. Ibrahim
  SurahInfo(isMadani: false, ayatCount: 99), // 15. Al-Hijr
  SurahInfo(isMadani: false, ayatCount: 128), // 16. An-Nahl
  SurahInfo(isMadani: false, ayatCount: 111), // 17. Al-Isra
  SurahInfo(isMadani: false, ayatCount: 110), // 18. Al-Kahf
  SurahInfo(isMadani: false, ayatCount: 98), // 19. Maryam
  SurahInfo(isMadani: false, ayatCount: 135), // 20. Ta-Ha
  SurahInfo(isMadani: false, ayatCount: 112), // 21. Al-Anbiya
  SurahInfo(isMadani: true, ayatCount: 78), // 22. Al-Hajj
  SurahInfo(isMadani: false, ayatCount: 118), // 23. Al-Mu'minun
  SurahInfo(isMadani: true, ayatCount: 64), // 24. An-Nur
  SurahInfo(isMadani: false, ayatCount: 77), // 25. Al-Furqan
  SurahInfo(isMadani: false, ayatCount: 227), // 26. Ash-Shu'ara
  SurahInfo(isMadani: false, ayatCount: 93), // 27. An-Naml
  SurahInfo(isMadani: false, ayatCount: 88), // 28. Al-Qasas
  SurahInfo(isMadani: false, ayatCount: 69), // 29. Al-Ankabut
  SurahInfo(isMadani: false, ayatCount: 60), // 30. Ar-Rum
  SurahInfo(isMadani: false, ayatCount: 34), // 31. Luqman
  SurahInfo(isMadani: false, ayatCount: 30), // 32. As-Sajdah
  SurahInfo(isMadani: true, ayatCount: 73), // 33. Al-Ahzab
  SurahInfo(isMadani: false, ayatCount: 54), // 34. Saba
  SurahInfo(isMadani: false, ayatCount: 45), // 35. Fatir
  SurahInfo(isMadani: false, ayatCount: 83), // 36. Ya-Sin
  SurahInfo(isMadani: false, ayatCount: 182), // 37. As-Saffat
  SurahInfo(isMadani: false, ayatCount: 88), // 38. Sad
  SurahInfo(isMadani: false, ayatCount: 75), // 39. Az-Zumar
  SurahInfo(isMadani: false, ayatCount: 85), // 40. Ghafir
  SurahInfo(isMadani: false, ayatCount: 54), // 41. Fussilat
  SurahInfo(isMadani: false, ayatCount: 53), // 42. Ash-Shura
  SurahInfo(isMadani: false, ayatCount: 89), // 43. Az-Zukhruf
  SurahInfo(isMadani: false, ayatCount: 59), // 44. Ad-Dukhan
  SurahInfo(isMadani: false, ayatCount: 37), // 45. Al-Jathiyah
  SurahInfo(isMadani: false, ayatCount: 35), // 46. Al-Ahqaf
  SurahInfo(isMadani: true, ayatCount: 38), // 47. Muhammad
  SurahInfo(isMadani: true, ayatCount: 29), // 48. Al-Fath
  SurahInfo(isMadani: true, ayatCount: 18), // 49. Al-Hujurat
  SurahInfo(isMadani: false, ayatCount: 45), // 50. Qaf
  SurahInfo(isMadani: false, ayatCount: 60), // 51. Adh-Dhariyat
  SurahInfo(isMadani: false, ayatCount: 49), // 52. At-Tur
  SurahInfo(isMadani: false, ayatCount: 62), // 53. An-Najm
  SurahInfo(isMadani: false, ayatCount: 55), // 54. Al-Qamar
  SurahInfo(isMadani: true, ayatCount: 78), // 55. Ar-Rahman
  SurahInfo(isMadani: false, ayatCount: 96), // 56. Al-Waqi'ah
  SurahInfo(isMadani: true, ayatCount: 29), // 57. Al-Hadid
  SurahInfo(isMadani: true, ayatCount: 22), // 58. Al-Mujadila
  SurahInfo(isMadani: true, ayatCount: 24), // 59. Al-Hashr
  SurahInfo(isMadani: true, ayatCount: 13), // 60. Al-Mumtahanah
  SurahInfo(isMadani: true, ayatCount: 14), // 61. As-Saff
  SurahInfo(isMadani: true, ayatCount: 11), // 62. Al-Jumu'ah
  SurahInfo(isMadani: true, ayatCount: 11), // 63. Al-Munafiqun
  SurahInfo(isMadani: true, ayatCount: 18), // 64. At-Taghabun
  SurahInfo(isMadani: true, ayatCount: 12), // 65. At-Talaq
  SurahInfo(isMadani: true, ayatCount: 12), // 66. At-Tahrim
  SurahInfo(isMadani: false, ayatCount: 30), // 67. Al-Mulk
  SurahInfo(isMadani: false, ayatCount: 52), // 68. Al-Qalam
  SurahInfo(isMadani: false, ayatCount: 52), // 69. Al-Haqqah
  SurahInfo(isMadani: false, ayatCount: 44), // 70. Al-Ma'arij
  SurahInfo(isMadani: false, ayatCount: 28), // 71. Nuh
  SurahInfo(isMadani: false, ayatCount: 28), // 72. Al-Jinn
  SurahInfo(isMadani: false, ayatCount: 20), // 73. Al-Muzzammil
  SurahInfo(isMadani: false, ayatCount: 56), // 74. Al-Muddaththir
  SurahInfo(isMadani: false, ayatCount: 40), // 75. Al-Qiyamah
  SurahInfo(isMadani: true, ayatCount: 31), // 76. Al-Insan
  SurahInfo(isMadani: false, ayatCount: 50), // 77. Al-Mursalat
  SurahInfo(isMadani: false, ayatCount: 40), // 78. An-Naba
  SurahInfo(isMadani: false, ayatCount: 46), // 79. An-Nazi'at
  SurahInfo(isMadani: false, ayatCount: 42), // 80. Abasa
  SurahInfo(isMadani: false, ayatCount: 29), // 81. At-Takwir
  SurahInfo(isMadani: false, ayatCount: 19), // 82. Al-Infitar
  SurahInfo(isMadani: false, ayatCount: 36), // 83. Al-Mutaffifin
  SurahInfo(isMadani: false, ayatCount: 25), // 84. Al-Inshiqaq
  SurahInfo(isMadani: false, ayatCount: 22), // 85. Al-Buruj
  SurahInfo(isMadani: false, ayatCount: 17), // 86. At-Tariq
  SurahInfo(isMadani: false, ayatCount: 19), // 87. Al-A'la
  SurahInfo(isMadani: false, ayatCount: 26), // 88. Al-Ghashiyah
  SurahInfo(isMadani: false, ayatCount: 30), // 89. Al-Fajr
  SurahInfo(isMadani: false, ayatCount: 20), // 90. Al-Balad
  SurahInfo(isMadani: false, ayatCount: 15), // 91. Ash-Shams
  SurahInfo(isMadani: false, ayatCount: 21), // 92. Al-Layl
  SurahInfo(isMadani: false, ayatCount: 11), // 93. Ad-Duha
  SurahInfo(isMadani: false, ayatCount: 8), // 94. Ash-Sharh
  SurahInfo(isMadani: false, ayatCount: 8), // 95. At-Tin
  SurahInfo(isMadani: false, ayatCount: 19), // 96. Al-Alaq
  SurahInfo(isMadani: false, ayatCount: 5), // 97. Al-Qadr
  SurahInfo(isMadani: true, ayatCount: 8), // 98. Al-Bayyinah
  SurahInfo(isMadani: true, ayatCount: 8), // 99. Az-Zalzalah
  SurahInfo(isMadani: false, ayatCount: 11), // 100. Al-Adiyat
  SurahInfo(isMadani: false, ayatCount: 11), // 101. Al-Qari'ah
  SurahInfo(isMadani: false, ayatCount: 8), // 102. At-Takathur
  SurahInfo(isMadani: false, ayatCount: 3), // 103. Al-Asr
  SurahInfo(isMadani: false, ayatCount: 9), // 104. Al-Humazah
  SurahInfo(isMadani: false, ayatCount: 5), // 105. Al-Fil
  SurahInfo(isMadani: false, ayatCount: 4), // 106. Quraysh
  SurahInfo(isMadani: false, ayatCount: 7), // 107. Al-Ma'un
  SurahInfo(isMadani: false, ayatCount: 3), // 108. Al-Kawthar
  SurahInfo(isMadani: false, ayatCount: 6), // 109. Al-Kafirun
  SurahInfo(isMadani: true, ayatCount: 3), // 110. An-Nasr
  SurahInfo(isMadani: false, ayatCount: 5), // 111. Al-Masad
  SurahInfo(isMadani: false, ayatCount: 4), // 112. Al-Ikhlas
  SurahInfo(isMadani: false, ayatCount: 5), // 113. Al-Falaq
  SurahInfo(isMadani: false, ayatCount: 6), // 114. An-Nas
];
