import 'package:intl/intl.dart'; // Package for handling date formatting
import '../models/todo.dart';



class RepeatHelper {
  // Calculates the next deadline based on the selected repeat interval
  static DateTime calculateNextDeadline(DateTime currentDeadline, String repeatInterval) {
    switch (repeatInterval) {
      case 'weekly':
        return currentDeadline.add(Duration(days: 7));
      case 'monthly':
        return DateTime(currentDeadline.year, currentDeadline.month + 1, currentDeadline.day, currentDeadline.hour, currentDeadline.minute);
      case 'yearly':
        return DateTime(currentDeadline.year + 1, currentDeadline.month, currentDeadline.day, currentDeadline.hour, currentDeadline.minute);
      default:
        return currentDeadline;
    }
  }
}



