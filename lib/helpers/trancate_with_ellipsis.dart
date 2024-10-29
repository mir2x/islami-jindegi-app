String truncateWithEllipsis(String str, int cutoff) {
  return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}..';
}
