String fileSize(int bytes) {
  if (bytes >= 1048576) {
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  } else if (bytes >= 1024) {
    return '${(bytes / 1024).round()} KB';
  } else if (bytes > 0) {
    return '$bytes B';
  } else {
    return '';
  }
}
