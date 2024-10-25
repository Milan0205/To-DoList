import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../AddTask/AddTaskDialogScreen.dart';
import '../Model/TaskModel.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks when the app starts
  }

  // Method to load tasks from shared preferences and update the _tasks list
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        _tasks.addAll(savedTasks.map((task) => Task.fromJson(jsonDecode(task))));
      });
    }
  }

  // Method to save the current list of tasks to shared preferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  // Method to add a new task to the list and update shared preferences
  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
    _saveTasks();

    // Show SnackBar for task addition confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task added successfully!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Method to toggle the completion status of a task
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks();
  }

  // Method to delete all completed tasks from the list
  void _deleteCompletedTasks() {
    setState(() {
      _tasks.removeWhere((task) => task.isCompleted);
    });
    _saveTasks();

    // Show SnackBar for task deletion confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task Deleted successfully!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'To-Do List',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: _deleteCompletedTasks,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    color: task.isCompleted
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                subtitle: task.dueDate != null
                    ? Text('Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}')
                    : null,
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => _toggleTaskCompletion(index),
                  activeColor: Colors.indigo,
                ),
              ),
              if (index < _tasks.length - 1)
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog<Task>(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
          if (newTask != null) _addTask(newTask);
        },
        tooltip: 'Add Task',
        backgroundColor: Colors.indigo,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
