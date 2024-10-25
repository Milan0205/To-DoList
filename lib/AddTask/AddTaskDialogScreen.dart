import 'package:flutter/material.dart';

import '../Model/TaskModel.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  // To store the error messages
  String? _titleError;

  // Function to validate fields
  bool _validateFields() {
    setState(() {
      _titleError = _titleController.text.isEmpty ? 'Title is required' : null;
    });

    // If both fields are valid, return true; otherwise, return false
    return _titleError == null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              errorText: _titleError, // Display error text for title
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              setState(() {
                _dueDate = pickedDate;
              });
            },
            child: const Text('Select Due Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_validateFields()) {
              final newTask = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _dueDate,
              );
              Navigator.of(context).pop(newTask); // Add task and close dialog
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
