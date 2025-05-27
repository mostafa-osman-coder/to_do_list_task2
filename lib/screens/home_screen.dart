import 'package:flutter/material.dart';
import 'package:to_do_list_task2/widgets/input_section.dart';
import 'package:to_do_list_task2/widgets/task_list.dart';
import '../models/task.dart';
import '../services/task_storage.dart';


enum TaskFilter { all, pending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = TaskStorage();
  final _controller = TextEditingController();
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
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return (a.dueDate ?? DateTime.now())
          .compareTo(b.dueDate ?? DateTime.now());
    });
  }

  Future<void> _addTask(String title) async {
    if (title.trim().isEmpty) return;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      _tasks.add(Task(title: title, dueDate: date));
      _controller.clear();
      _sortTasks();
    });
    _saveTasks();
  }

  void _toggleTask(Task task) {
    final index = _tasks.indexOf(task);
    if (index == -1) return;

    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
      _sortTasks();
    });
    _saveTasks();
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
    _saveTasks();
  }

  List<Task> get _filteredTasks {
    if (_filter == TaskFilter.pending) {
      return _tasks.where((t) => !t.isDone).toList();
    }
    return _tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: (value) => setState(() => _filter = value),
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
          InputSection(
            controller: _controller,
            onAdd: () => _addTask(_controller.text),
          ),
          TaskList(
            tasks: _filteredTasks,
            onToggle: _toggleTask,
            onDelete: _deleteTask,
          ),
        ],
      ),
    );
  }
}
