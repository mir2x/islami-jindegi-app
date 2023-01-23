import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider = FutureProvider((ref) async {
  return await SharedPreferences.getInstance();
});
