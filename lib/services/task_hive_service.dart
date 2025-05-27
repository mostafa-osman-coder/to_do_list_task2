import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskHiveService {
  static const _boxName = 'tasksBox';

  Future<void> addTask(Task task) async {
    final box = await Hive.openBox<Task>(_boxName);
    await box.add(task);
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<List<Task>> getTasks() async {
    final box = await Hive.openBox<Task>(_boxName);
    return box.values.toList();
  }

  Future<void> clearAll() async {
    final box = await Hive.openBox<Task>(_boxName);
    await box.clear();
  }
}
