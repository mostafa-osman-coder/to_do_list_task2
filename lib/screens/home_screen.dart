import 'package:flutter/material.dart';
import 'package:to_do_list_task2/widgets/input_section.dart';
import 'package:to_do_list_task2/widgets/task_list.dart';
import '../models/task.dart';
import '../services/task_hive_service.dart';


enum TaskFilter { all, pending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _hiveService = TaskHiveService();
  final _controller = TextEditingController();
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  // ignore: unused_field
  Task? _recentlyDeleted;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _hiveService.getTasks();
    setState(() {
      _tasks = tasks;
      _sortTasks();
    });
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      return (a.dueDate ?? DateTime.now()).compareTo(b.dueDate ?? DateTime.now());
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

    final task = Task(title: title, dueDate: date);
    await _hiveService.addTask(task);

    setState(() {
      _tasks.add(task);
      _controller.clear();
      _sortTasks();
    });
  }

  Future<void> _toggleTask(Task task) async {
    task.isDone = !task.isDone;
    await _hiveService.updateTask(task);
    _sortTasks();
    setState(() {});
  }

  Future<void> _deleteTask(Task task) async {
    _recentlyDeleted = task;
    await _hiveService.deleteTask(task);

    setState(() {
      _tasks.remove(task);
    });
  }

  Future<void> _undoDelete(Task task) async {
    await _hiveService.addTask(task);
    setState(() {
      _tasks.add(task);
      _sortTasks();
      _recentlyDeleted = null;
    });
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
            onDelete: (task) {
              _deleteTask(task);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => _undoDelete(task),
                  ),
                ),
              );
            },
            onUndo: _undoDelete,
          ),
        ],
      ),
    );
  }
}
