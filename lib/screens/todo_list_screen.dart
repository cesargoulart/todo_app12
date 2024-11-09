import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../database/database_helper.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/edit_todo_dialog.dart';
import '../widgets/repeat_helper.dart';
import '../widgets/task_visibility_helper.dart';
import '../widgets/deadline_filter_helper.dart';
import '../widgets/deadline_notifier.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  final TaskVisibilityHelper visibilityHelper = TaskVisibilityHelper();
  final DeadlineFilterHelper deadlineFilterHelper = DeadlineFilterHelper();
  bool showTasksEndingSoon = false;
  late DeadlineNotifier deadlineNotifier;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    deadlineNotifier.stopDeadlineCheck();  // Stop the deadline check timer
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getTasks();
    setState(() {
      todos = tasks;
      deadlineNotifier = DeadlineNotifier(context: context, tasks: todos);
      deadlineNotifier.startDeadlineCheck();  // Start deadline notifications
    });
  }

  Future<void> _addTodo(String title, String description, String? repeatInterval, DateTime deadline) async {
    final newTodo = Todo(
      title: title,
      description: description,
      dueDate: deadline,
      repeatInterval: repeatInterval,
    );
    await DatabaseHelper.instance.insertTask(newTodo);
    _loadTasks();  // Reload tasks after adding
  }

Future<void> _editTodo(Todo task, String newTitle, String newDescription, String? newRepeatInterval, DateTime newDeadline) async {
  setState(() {
    task.title = newTitle;
    task.description = newDescription;
    task.repeatInterval = newRepeatInterval;
    task.dueDate = newDeadline;
  });
  await DatabaseHelper.instance.updateTask(task);
  _loadTasks();  // Reload tasks after editing
}


  Future<void> _deleteTodo(Todo task) async {
    await DatabaseHelper.instance.deleteTask(task.id!);
    _loadTasks();  // Reload tasks after deletion
  }

  void _toggleVisibility() {
    setState(() {
      visibilityHelper.toggleHideCompleted();
    });
  }

  void _toggleDeadlineFilter() {
    setState(() {
      showTasksEndingSoon = !showTasksEndingSoon;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Apply the visibility and deadline filters
    List<Todo> visibleTodos = visibilityHelper.filterTasks(todos);
    if (showTasksEndingSoon) {
      visibleTodos = deadlineFilterHelper.filterTasksWithUpcomingDeadlines(visibleTodos);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(
              visibilityHelper.hideCompleted
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: _toggleVisibility,
          ),
          IconButton(
            icon: Icon(
              showTasksEndingSoon ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: showTasksEndingSoon ? Colors.blue : null,
            ),
            onPressed: _toggleDeadlineFilter,
            tooltip: 'Show tasks ending in 3 days',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: visibleTodos.length,
        itemBuilder: (context, index) {
          final task = visibleTodos[index];
          final formattedDeadline = DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate);
          final repeatText = task.repeatInterval != null ? 'Repeats: ${task.repeatInterval!.capitalize()}' : 'No Repeat';

          return ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description),
                SizedBox(height: 4),
                Text(
                  "Deadline: $formattedDeadline",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (task.repeatInterval != null)
                  Text(
                    repeatText,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (bool? value) async {
                    setState(() {
                      task.isCompleted = value!;
                    });
                    await DatabaseHelper.instance.updateTask(task);
                    _loadTasks();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => EditTodoDialog(task: task),
                    );
                    if (result != null) {
                      _editTodo(
                        task,
                        result['title']!,
                        result['description']!,
                        result['repeatInterval'],
                        result['deadline'],

                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTodo(task),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => AddTodoDialog(),
          );
          if (result != null) {
            _addTodo(
              result['title']!,
              result['description']!,
              result['repeatInterval'],
              result['deadline'],
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
