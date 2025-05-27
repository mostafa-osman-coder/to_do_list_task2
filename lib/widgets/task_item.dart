import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getTileColor(Task task) {
    if (task.isDone) return Colors.grey.shade200;
    if (task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      return Colors.orange.shade50;
    }
    return Colors.white;
  }

  String? _getDueInfo(Task task) {
    if (task.dueDate == null) return null;
    final now = DateTime.now();
    final diff = task.dueDate!.difference(now).inDays;
    if (diff < 0) return '⏰ Overdue';
    if (diff == 0) return '⏳ Due today';
    return '📅 In $diff day${diff > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _getTileColor(task),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            color: task.isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text(
                _getDueInfo(task)!,
                style: TextStyle(
                  color: task.dueDate!.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.teal,
                  fontSize: 12,
                ),
              )
            : null,
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => onToggle(),
          shape: const CircleBorder(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
