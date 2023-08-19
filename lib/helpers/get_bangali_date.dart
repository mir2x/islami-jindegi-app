import 'package:native_app/objects/bongabdo.dart';

String getBangaliDate() {
  final today = Bongabdo.now();
  return '${today.bDay} ${today.bMonth}, ${today.bYear} বঙ্গাব্দ';
}
