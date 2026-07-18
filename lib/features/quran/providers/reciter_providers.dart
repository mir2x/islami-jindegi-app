import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _selectedReciterKey = 'sura_selected_reciter';

final Map<String, String> reciters = {
  'আব্দুল্লাহ আল জুহানী': 'abdullah-al-joohani',
  'আব্দুর রহমান আল সুদাইস': 'abdur-rahman-al-sudais',
  'ফারিস আব্বাদ': 'farees-abbad',
  'মিশারি রাশিদ আলাফাসি': 'mishary-bin-rashid-alafasy',
  'আব্দুল বাসিত আব্দুস সামাদ': 'qari-abdul-basit',
  'মাহের আল মুয়াইক্বিলি': 'qari-maher-al-muaiqly',
  'সৌদ আল-শুরাইম': 'qari-saud-bin-ibrahim-ash-shuraim',
};

class SelectedReciterNotifier extends Notifier<String> {
  @override
  String build() {
    _loadFromPrefs();
    return 'qari-maher-al-muaiqly';
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_selectedReciterKey);
    if (saved != null && reciters.containsValue(saved)) {
      state = saved;
    }
  }

  Future<void> setReciter(String reciterId) async {
    state = reciterId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedReciterKey, reciterId);
  }
}

final selectedReciterProvider =
    NotifierProvider<SelectedReciterNotifier, String>(SelectedReciterNotifier.new);
