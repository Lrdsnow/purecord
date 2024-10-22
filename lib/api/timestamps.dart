import 'package:intl/intl.dart';

String formatTimestamp(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp).toLocal();

  DateFormat formatter = DateFormat('MMMM d, yyyy');

  return formatter.format(dateTime);
}

bool areTimestampsOnSameDay(String timestamp1, String timestamp2) {
  DateTime dateTime1 = DateTime.parse(timestamp1).toLocal();
  DateTime dateTime2 = DateTime.parse(timestamp2).toLocal();

  return dateTime1.year == dateTime2.year &&
         dateTime1.month == dateTime2.month &&
         dateTime1.day == dateTime2.day;
}

String formatTimestampForMessages(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();

  DateFormat dateFormat = DateFormat('MM/dd/yyyy');
  DateFormat timeFormat = DateFormat('hh:mm a');

  if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
    return 'Today, ${timeFormat.format(dateTime)}';
  } else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day - 1) {
    return 'Yesterday, ${timeFormat.format(dateTime)}';
  } else {
    return '${dateFormat.format(dateTime)}, ${timeFormat.format(dateTime)}';
  }
}