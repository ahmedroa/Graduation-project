extension DateTimeExtension on int {
  String getTimeAgo() {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 1) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays == 1) {
      return 'منذ يوم واحد';
    } else if (difference.inHours > 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inHours == 1) {
      return 'منذ ساعة واحدة';
    } else if (difference.inMinutes > 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inMinutes == 1) {
      return 'منذ دقيقة واحدة';
    } else {
      return 'الآن';
    }
  }
}