String playTime(int seconds) {
  int hour = seconds ~/ 3600;
  int remainingSeconds = seconds - (hour * 3600);
  int minute = remainingSeconds ~/ 60;
  int second = remainingSeconds % 60;

  if (hour > 0) {
    return '$hour:${padZero(minute)}:${padZero(second)}';
  } else {
    return '$minute:${padZero(second)}';
  }
}

String padZero(int num) {
  return num.toString().padLeft(2, '0');
}
