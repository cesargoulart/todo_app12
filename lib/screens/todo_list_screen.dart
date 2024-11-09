import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../database/database_helper.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/edit_todo_dialog.dart';
import '../widgets/repeat_helper.dart';
import '../widgets/task_visibility_helper.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  final TaskVisibilityHelper visibilityHelper = TaskVisibilityHelper();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getTasks();
    setState(() {
      todos = tasks;
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

  Future<void> _editTodo(Todo task, String newTitle, String newDescription, String? newRepeatInterval) async {
    setState(() {
      task.title = newTitle;
      task.description = newDescription;
      task.repeatInterval = newRepeatInterval;
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

  @override
  Widget build(BuildContext context) {
    List<Todo> visibleTodos = visibilityHelper.filterTasks(todos);

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
        ],
      ),
      body: ListView.builder(
        itemCount: visibleTodos.length,
        itemBuilder: (context, index) {
          final task = visibleTodos[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
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
