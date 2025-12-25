import 'package:flutter/material.dart';

/// Quick Add Task Input
/// Simple input for quickly adding tasks (opens full dialog for details)
class AddTaskInput extends StatefulWidget {
  final Function() onAddPressed;

  const AddTaskInput({Key? key, required this.onAddPressed}) : super(key: key);

  @override
  State<AddTaskInput> createState() => _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onAddPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Add a new task...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
