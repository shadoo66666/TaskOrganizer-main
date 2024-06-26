import 'package:flutter/material.dart';
import 'package:task_app/widget/task%20(1)/task/add_new_task.dart';

class AddTaskButton extends StatelessWidget {
    final String userId; // Add userId property

  const AddTaskButton({
    Key? key,
    required this.userId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        builder: (context) => AddNewTaskSheet(userId: userId), 
      ),
      shape: const CircleBorder(),
      child: const Text('+ Task'),
    );
  }
}
