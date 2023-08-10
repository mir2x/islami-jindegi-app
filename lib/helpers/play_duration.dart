String playDuration(dynamic seconds) {
  if (seconds is String) {
    seconds = int.parse(seconds);
  }

  int hour = seconds ~/ 3600;
  int remainingSeconds = seconds - hour * 3600;
  int minute = remainingSeconds ~/ 60;
  int second = remainingSeconds % 60;

  String duration = hour > 0 ? '$hour hr' : '';
  duration = minute > 0 ? '$duration $minute min' : duration;
  duration = second > 0 && hour == 0 ? '$duration $second sec' : duration;
  return duration.trim();
}
