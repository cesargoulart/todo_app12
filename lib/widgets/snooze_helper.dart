import '../models/todo.dart';
import '../database/database_helper.dart';

class SnoozeHelper {
  // Extends the task's deadline by one hour
  Future<void> snoozeTask(Todo task) async {
    final newDeadline = task.dueDate.add(Duration(hours: 1));
    task.dueDate = newDeadline;
    
    // Update the deadline in the database
    await DatabaseHelper.instance.updateTask(task);
  }
}
