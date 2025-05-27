import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_item.dart';

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
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Text('All Tasks'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task...',
                      prefixIcon: Icon(Icons.task_alt),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _addTask(_controller.text),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskItem(
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
