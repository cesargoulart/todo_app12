import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'date_picker_widget.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo task;

  EditTodoDialog({required this.task});

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? selectedRepeatInterval;
  late DateTime selectedDeadline;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and deadline with the existing task data
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    selectedRepeatInterval = widget.task.repeatInterval;
    selectedDeadline = widget.task.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<String>(
              value: selectedRepeatInterval,
              items: [
                DropdownMenuItem(child: Text("No Repeat"), value: null),
                DropdownMenuItem(child: Text("Weekly"), value: "weekly"),
                DropdownMenuItem(child: Text("Monthly"), value: "monthly"),
                DropdownMenuItem(child: Text("Yearly"), value: "yearly"),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRepeatInterval = value;
                });
              },
              decoration: InputDecoration(labelText: 'Repeat'),
            ),
            SizedBox(height: 20),
            DatePickerWidget(
              initialDate: selectedDeadline,
              onDateTimeSelected: (dateTime) {
                setState(() {
                  selectedDeadline = dateTime;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'title': titleController.text,
              'description': descriptionController.text,
              'repeatInterval': selectedRepeatInterval,
              'deadline': selectedDeadline,
            });
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
