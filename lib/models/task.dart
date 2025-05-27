import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  final DateTime? dueDate;

  Task({
    required this.title,
    this.isDone = false,
    this.dueDate,
  });
}
