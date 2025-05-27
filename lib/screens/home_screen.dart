import 'package:flutter/material.dart';
import 'package:to_do_list_task2/widgets/task_item.dart';
import '../models/task.dart';
import '../services/task_storage.dart';

enum TaskFilter { all, pending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskStorage _storage = TaskStorage();
  final TextEditingController _controller = TextEditingController();
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.loadTasks();
    setState(() {
      _tasks = tasks;
      _sortTasks();
    });
  }

  Future<void> _saveTasks() async {
    await _storage.saveTasks(_tasks);
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone != b.isDone) {
        return a.isDone ? 1 : -1;
      } else {
        return (a.dueDate ?? DateTime.now())
            .compareTo(b.dueDate ?? DateTime.now());
      }
    });
  }

  void _addTask(String title) async {
    if (title.trim().isEmpty) return;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      _tasks.add(Task(title: title, dueDate: selectedDate));
      _controller.clear();
      _sortTasks();
    });
    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
      _sortTasks();
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filter == TaskFilter.pending
        ? _tasks.where((t) => !t.isDone).toList()
        : _tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Text('Show All'),
              ),
              PopupMenuItem(
                value: TaskFilter.pending,
                child: Text('Pending Only'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  child: const Text('Add'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return  TaskItem(
                         task: task,
                         onToggle: () => _toggleTask(_tasks.indexOf(task)),
                         onDelete: () => _deleteTask(_tasks.indexOf(task)),
                         );

              },
            ),
          ),
        ],
      ),
    );
  }
}
