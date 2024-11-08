import '../models/todo.dart';

class TaskVisibilityHelper {
  // Initial state: show all tasks, including completed ones
  bool _hideCompleted = false;

  // Getter for current visibility state
  bool get hideCompleted => _hideCompleted;

  // Toggle the hideCompleted state
  void toggleHideCompleted() {
    _hideCompleted = !_hideCompleted;
  }

  // Function to filter tasks based on visibility state
  List<Todo> filterTasks(List<Todo> todos) {
    if (_hideCompleted) {
      return todos.where((task) => !task.isCompleted).toList();
    }
    return todos;
  }
}
