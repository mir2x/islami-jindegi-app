const suraListRoute = '/qurans/sura-list';

String buildSuraRoute({
  required int suraNumber,
  int? scrollIndex,
  String returnTo = suraListRoute,
}) {
  return Uri(
    path: '/qurans/sura/$suraNumber',
    queryParameters: {
      if (scrollIndex != null) 'scroll': '$scrollIndex',
      'returnTo': returnTo,
    },
  ).toString();
}

String buildTilawatRoute({
  required int suraNumber,
  required int ayahNumber,
  String returnTo = suraListRoute,
}) {
  return Uri(
    path: '/qurans/tilawat',
    queryParameters: {
      'sura': '$suraNumber',
      'ayah': '$ayahNumber',
      'returnTo': returnTo,
    },
  ).toString();
}

String buildSearchRoute({
  String returnTo = suraListRoute,
}) {
  return Uri(
    path: '/qurans/search',
    queryParameters: {
      'returnTo': returnTo,
    },
  ).toString();
}
