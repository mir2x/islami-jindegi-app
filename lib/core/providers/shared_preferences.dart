import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The preferences instance created before `runApp`.
///
/// Keeping this synchronous prevents persisted UI state from briefly being
/// unavailable on the first build of a cold launch.
final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError('SharedPreferences must be overridden at startup');
});
