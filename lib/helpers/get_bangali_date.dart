import 'package:native_app/objects/bongabdo.dart';

String getBangaliDate() {
  final today = Bongabdo.now('new');
  return '${today.bDay} ${today.bMonth}, ${today.bYear} ${today.bSeason}কাল';
}
