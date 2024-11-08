class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  String? repeatInterval; // New field for the repeat interval
  

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    this.repeatInterval, // Initialize new field
    
  });
}
