import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/edit_todo_dialog.dart';
import '../widgets/repeat_helper.dart';
import '../widgets/task_visibility_helper.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [
    Todo(title: 'Buy groceries', description: 'Milk, Eggs, Bread, Butter', dueDate: DateTime.now()),
    Todo(title: 'Workout', description: '1-hour gym session', dueDate: DateTime.now()),
    Todo(title: 'Study Flutter', description: 'Complete the Todo app project', dueDate: DateTime.now()),
  ];

  final TaskVisibilityHelper visibilityHelper = TaskVisibilityHelper();

  void _addTodo(String title, String description, String? repeatInterval) {
    setState(() {
      todos.add(Todo(
        title: title,
        description: description,
        dueDate: DateTime.now(),
        repeatInterval: repeatInterval,
      ));
    });
  }

  void _editTodo(Todo task, String newTitle, String newDescription) {
    setState(() {
      task.title = newTitle;
      task.description = newDescription;
    });
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
                  onChanged: (bool? value) {
                    setState(() {
                      task.isCompleted = value!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await showDialog<Map<String, String>>(
                      context: context,
                      builder: (context) => EditTodoDialog(task: task),
                    );
                    if (result != null) {
                      _editTodo(task, result['title']!, result['description']!);
                    }
                  },
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
            _addTodo(result['title'], result['description'], result['repeatInterval']);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
