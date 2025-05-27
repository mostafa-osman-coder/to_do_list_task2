import 'package:flutter/material.dart';
import 'package:to_do_list_task2/widgets/task_item.dart';
import '../../models/task.dart';


class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task task) onToggle;
  final void Function(Task task) onDelete;
  final void Function(Task task) onUndo;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.key.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              onDelete(task);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => onUndo(task),
                  ),
                ),
              );
            },
            child: TaskItem(
              task: task,
              onToggle: () => onToggle(task),
              onDelete: () => onDelete(task), // still here if needed for button
            ),
          );
        },
      ),
    );
  }
}
