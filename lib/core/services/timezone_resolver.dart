import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tz_polygon;
import 'package:shared_preferences/shared_preferences.dart';

import 'timezone_api.dart';
import 'timezone_database.dart';

/// The single place a time zone is decided in this app.
///
/// A coordinate's zone must be derived from the coordinate. It was previously
/// derived from the country code by taking that country's first listed zone,
/// which put every US location on America/Adak — two hours off Los Angeles,
/// five off New York. 24 countries span more than one UTC offset, so no
/// country-level mapping can be correct. Nothing outside this file may resolve
/// a zone; there is deliberately no country-code path left to fall back to.
///
/// Order of authority:
///   1. cached answer, when it still applies to these coordinates
///   2. the backend, so a boundary change is fixable without an app release
///   3. the on-device polygon lookup, which is the only option offline and in
///      the background isolates that draw the home screen widget
///
/// Bumped when the resolution strategy changes in a way that invalidates every
/// answer already on disk. Installs carrying a country-derived zone have no
/// version at all, so they re-resolve on first launch after this ships.
const int timezoneSchemaVersion = 2;

const String _prefsTimezone = 'timezone';
const String _prefsLatitude = 'timezoneLatitude';
const String _prefsLongitude = 'timezoneLongitude';
const String _prefsOfflineId = 'timezoneOfflineId';
const String _prefsSchemaVersion = 'timezoneSchemaVersion';
const String _prefsSource = 'timezoneSource';

/// Coordinates within this distance reuse the cached zone rather than calling
/// the backend again. GPS jitters by tens of metres while standing still, and
/// a fresh network round trip per fix would put the prayer times behind a
/// spinner all day. A boundary crossing inside the tolerance is caught by the
/// offline-id tripwire below, not by this number.
const double _coordinateToleranceDegrees = 0.02; // ~2.2 km

/// Returns the IANA zone for [latitude]/[longitude] and persists it.
///
/// Never throws and never returns an unresolvable id: on total failure it
/// returns the previously stored zone, or an empty string if there is none.
/// An empty result means "unknown", and callers must not silently substitute
/// the device zone for it — for a location abroad that is a wrong answer that
/// looks like a right one.
///
/// The backend is consulted but not waited for whenever the offline lookup
/// already has an answer. This sits in front of the prayer times on every cold
/// start after an upgrade, and a user opening the app on a plane should not
/// watch a request time out to be told what a local polygon test could answer
/// instantly. A server-side correction therefore lands in preferences and takes
/// effect on the next resolve rather than the current one — the right trade for
/// a border that moves once every few years.
Future<String> resolveTimezone({
  required double latitude,
  required double longitude,
  bool allowNetwork = true,
}) async {
  final preferences = await SharedPreferences.getInstance();

  // Free, offline, and needed on every path: it is both the fallback answer and
  // the tripwire that tells us a cached answer has stopped applying.
  final offlineId = _offlineLookup(latitude, longitude);

  final cached = _cachedTimezone(preferences, latitude, longitude, offlineId);
  if (cached != null) return cached;

  if (offlineId != null) {
    await _persist(
      preferences,
      zoneId: offlineId,
      latitude: latitude,
      longitude: longitude,
      offlineId: offlineId,
      source: 'offline',
    );
    debugPrint('[Timezone] Resolved ($latitude, $longitude) -> $offlineId '
        '(via offline).');

    if (allowNetwork) {
      unawaited(_confirmWithBackend(latitude, longitude, offlineId));
    }
    return offlineId;
  }

  // Nothing offline covers this point, so the backend is the only answer left
  // and is worth waiting for.
  if (allowNetwork) {
    final backendId = await _backendLookup(preferences, latitude, longitude);
    if (backendId != null) {
      await _persist(
        preferences,
        zoneId: backendId,
        latitude: latitude,
        longitude: longitude,
        offlineId: null,
        source: 'backend',
      );
      debugPrint('[Timezone] Resolved ($latitude, $longitude) -> $backendId '
          '(via backend).');
      return backendId;
    }
  }

  // Both lookups failed. Keep whatever is already stored rather than replacing
  // a good answer with nothing.
  final previous = preferences.getString(_prefsTimezone) ?? '';
  debugPrint('[Timezone] Unresolved for ($latitude, $longitude). '
      'Keeping stored zone: "${previous.isEmpty ? '<none>' : previous}".');
  return previous;
}

/// Replaces the offline answer if the backend disagrees with it.
///
/// Runs after its caller has already returned, so it re-reads preferences and
/// checks that the coordinates it was asked about are still the ones in effect
/// — a slow reply must not overwrite a location the user has since changed.
Future<void> _confirmWithBackend(
  double latitude,
  double longitude,
  String offlineId,
) async {
  final preferences = await SharedPreferences.getInstance();
  final backendId = await _backendLookup(preferences, latitude, longitude);
  if (backendId == null || backendId == offlineId) return;

  if (preferences.getDouble(_prefsLatitude) != latitude ||
      preferences.getDouble(_prefsLongitude) != longitude) {
    debugPrint('[Timezone] Backend named $backendId for ($latitude, '
        '$longitude), but the location has changed since. Discarding.');
    return;
  }

  debugPrint('[Timezone] Backend corrected $offlineId -> $backendId for '
      '($latitude, $longitude).');
  await _persist(
    preferences,
    zoneId: backendId,
    latitude: latitude,
    longitude: longitude,
    offlineId: offlineId,
    source: 'backend',
  );
}

/// The zone currently on disk, or an empty string when none has been resolved
/// yet or the stored one predates the current strategy.
///
/// Read-only: callers that can supply coordinates should use [resolveTimezone]
/// instead so a stale answer gets corrected.
Future<String> storedTimezone() async {
  final preferences = await SharedPreferences.getInstance();
  if (preferences.getInt(_prefsSchemaVersion) != timezoneSchemaVersion) {
    return '';
  }
  final zoneId = preferences.getString(_prefsTimezone) ?? '';
  return isResolvableTimezone(zoneId) ? zoneId : '';
}

/// Drops the cached zone so the next [resolveTimezone] re-derives it. Used when
/// the stored coordinates change through a path that cannot resolve on the
/// spot.
Future<void> invalidateStoredTimezone() async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.remove(_prefsSchemaVersion);
}

String? _cachedTimezone(
  SharedPreferences preferences,
  double latitude,
  double longitude,
  String? offlineId,
) {
  if (preferences.getInt(_prefsSchemaVersion) != timezoneSchemaVersion) {
    return null;
  }

  final zoneId = preferences.getString(_prefsTimezone);
  if (zoneId == null || !isResolvableTimezone(zoneId)) return null;

  final cachedLatitude = preferences.getDouble(_prefsLatitude);
  final cachedLongitude = preferences.getDouble(_prefsLongitude);
  if (cachedLatitude == null || cachedLongitude == null) return null;

  if ((cachedLatitude - latitude).abs() > _coordinateToleranceDegrees ||
      (cachedLongitude - longitude).abs() > _coordinateToleranceDegrees) {
    return null;
  }

  // Within the tolerance the coordinates are treated as the same place — unless
  // the polygon lookup now names a different zone, which means a border runs
  // between the two points and the cached answer no longer applies.
  if (preferences.getString(_prefsOfflineId) != offlineId) return null;

  return zoneId;
}

/// The polygon lookup returns the literal string "unknown" rather than throwing
/// when a point falls outside its data, which would otherwise be persisted as
/// if it were a zone name.
String? _offlineLookup(double latitude, double longitude) {
  try {
    final zoneId = tz_polygon.latLngToTimezoneString(latitude, longitude);
    if (zoneId.isEmpty || zoneId == 'unknown') return null;
    return isResolvableTimezone(zoneId) ? zoneId : null;
  } catch (error) {
    debugPrint('[Timezone] Offline lookup failed: $error');
    return null;
  }
}

Future<String?> _backendLookup(
  SharedPreferences preferences,
  double latitude,
  double longitude,
) async {
  // Persisted by main() so the background isolates, which have no dotenv, can
  // still reach the backend.
  final host = preferences.getString('hijriBackendUrl');
  if (host == null || host.isEmpty) return null;

  try {
    final zoneId = await TimezoneApi(host).resolve(
      latitude: latitude,
      longitude: longitude,
    );
    if (zoneId == null) return null;

    if (!isResolvableTimezone(zoneId)) {
      debugPrint('[Timezone] Backend returned unresolvable zone "$zoneId". '
          'Falling back to the offline lookup.');
      return null;
    }
    return zoneId;
  } catch (error) {
    debugPrint('[Timezone] Backend lookup failed: $error');
    return null;
  }
}

Future<void> _persist(
  SharedPreferences preferences, {
  required String zoneId,
  required double latitude,
  required double longitude,
  required String? offlineId,
  required String source,
}) async {
  await preferences.setString(_prefsTimezone, zoneId);
  await preferences.setDouble(_prefsLatitude, latitude);
  await preferences.setDouble(_prefsLongitude, longitude);
  if (offlineId == null) {
    await preferences.remove(_prefsOfflineId);
  } else {
    await preferences.setString(_prefsOfflineId, offlineId);
  }
  await preferences.setString(_prefsSource, source);
  await preferences.setInt(_prefsSchemaVersion, timezoneSchemaVersion);
}
