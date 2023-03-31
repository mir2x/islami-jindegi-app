String contextualTranslation({
  required String locale,
  required String enText,
  String? bnText,
}) {
  return (locale == 'bn' && bnText != null) ? bnText : enText;
}
