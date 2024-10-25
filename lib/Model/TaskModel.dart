// Task Model

class Task {
  String title;
  String? description;
  DateTime? dueDate;
  bool isCompleted;

  Task({required this.title, this.description, this.dueDate, this.isCompleted = false});

  // For saving/loading tasks to SharedPreferences
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  static Task fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    isCompleted: json['isCompleted'],
  );
}
