import 'package:intl/intl.dart';

String timeAgo(String timestamp) {
  DateTime postTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timestamp);
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(postTime);

  if (difference.inSeconds <= 60) {
    return "just now";
  } else if (difference.inMinutes <= 60) {
    return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
  } else if (difference.inHours <= 24) {
    return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
  } else if (difference.inDays <= 7) {
    return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
  } else {
    return DateFormat('MMM d, yyyy').format(postTime);
  }
}
