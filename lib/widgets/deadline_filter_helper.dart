import '../models/todo.dart';

class DeadlineFilterHelper {
  // Filters tasks with deadlines within the next 3 days
  List<Todo> filterTasksWithUpcomingDeadlines(List<Todo> tasks) {
    final now = DateTime.now();
    final threeDaysFromNow = now.add(Duration(days: 3));

    return tasks.where((task) {
      return task.dueDate.isAfter(now) && task.dueDate.isBefore(threeDaysFromNow);
    }).toList();
  }
}
