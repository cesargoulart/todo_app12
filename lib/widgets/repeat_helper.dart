import 'package:intl/intl.dart'; // Package for handling date formatting
import '../models/todo.dart';

class RepeatHelper {
  // Method to calculate the next due date based on the repeat interval
  static DateTime calculateNextDueDate(DateTime currentDueDate, String repeatInterval) {
    switch (repeatInterval) {
      case 'weekly':
        return currentDueDate.add(Duration(days: 7));
      case 'monthly':
        return DateTime(currentDueDate.year, currentDueDate.month + 1, currentDueDate.day);
      case 'yearly':
        return DateTime(currentDueDate.year + 1, currentDueDate.month, currentDueDate.day);
      default:
        return currentDueDate;
    }
  }

  // Method to duplicate task based on repeat interval
  static Todo createRepeatedTask(Todo task) {
    DateTime nextDueDate = calculateNextDueDate(task.dueDate, task.repeatInterval!);
    return Todo(
      title: task.title,
      description: task.description,
      dueDate: nextDueDate,
      repeatInterval: task.repeatInterval,
    );
  }
}
