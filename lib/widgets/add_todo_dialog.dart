import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? selectedRepeatInterval;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Todo'),
      content: Column(
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
        ],
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
            });
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
