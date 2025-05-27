class Task {
  final String title;
  bool isDone;
  final DateTime? dueDate;

  Task({required this.title, this.isDone = false, this.dueDate});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
        'dueDate': dueDate?.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
    );
  }
}