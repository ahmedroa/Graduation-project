String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return 'منذ ${difference.inDays} يوم';
  } else if (difference.inHours > 0) {
    return 'منذ ${difference.inHours} ساعة';
  } else if (difference.inMinutes > 0) {
    return 'منذ ${difference.inMinutes} دقيقة';
  } else {
    return 'الآن';
  }
}