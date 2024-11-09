class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;
  String? repeatInterval;
  DateTime dueDate;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.repeatInterval,
  });

  // Convert a Todo object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeatInterval': repeatInterval,
    };
  }

  // Convert a map into a Todo object
  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        isCompleted: json['isCompleted'] == 1,
        repeatInterval: json['repeatInterval'],
      );
}
