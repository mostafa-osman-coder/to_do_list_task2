import 'package:flutter/material.dart';
import 'package:to_do_list_task2/widgets/task_item.dart';
import '../../models/task.dart';


class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task task) onToggle;
  final void Function(Task task) onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete, required Future<void> Function(Task task) onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 12),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskItem(
            task: task,
            onToggle: () => onToggle(task),
            onDelete: () => onDelete(task),
          );
        },
      ),
    );
  }
}
