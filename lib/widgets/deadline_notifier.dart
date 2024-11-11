import 'dart:async';
import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'snooze_helper.dart';

class DeadlineNotifier {
  final BuildContext context;
  final List<Todo> tasks;
  final SnoozeHelper snoozeHelper = SnoozeHelper();
  final Function onTaskUpdated;  // Callback function to refresh the task list
  Timer? _timer;

  DeadlineNotifier({required this.context, required this.tasks, required this.onTaskUpdated});

  // Starts periodic checks for task deadlines
  void startDeadlineCheck() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkForExpiredTasks();
    });
  }

  // Stops the periodic deadline checks
  void stopDeadlineCheck() {
    _timer?.cancel();
  }

  // Checks for tasks whose deadline has passed
  void _checkForExpiredTasks() {
    final now = DateTime.now();

    for (var task in tasks) {
      if (!task.isCompleted && task.dueDate.isBefore(now)) {
        _showDeadlinePopup(task);
      }
    }
  }

  // Shows a popup when a task's deadline has passed
  void _showDeadlinePopup(Todo task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Task Deadline Reached'),
          content: Text('The deadline for "${task.title}" has passed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Dismiss'),
            ),
            TextButton(
              onPressed: () async {
                await snoozeHelper.snoozeTask(task);
                onTaskUpdated();  // Call the callback to refresh the task list
                Navigator.of(context).pop();
              },
              child: Text('Snooze +1 Hour'),
            ),
          ],
        );
      },
    );
  }
}
