import 'package:flutter/material.dart';

class PrioritySelectionDialog extends StatelessWidget {
  const PrioritySelectionDialog({super.key, required this.onPrioritySelected});

  final Function(String) onPrioritySelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Priority'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriorityOption(context, 'Urgent', Colors.red),
          _buildPriorityOption(context, 'High', Colors.orange),
          _buildPriorityOption(context, 'Normal', Colors.blue),
          _buildPriorityOption(context, 'Low', Colors.green),
          _buildPriorityOption(context, 'No Priority', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(BuildContext context, String priority, Color color) {
    return ListTile(
      title: Text(priority),
      onTap: () {
        onPrioritySelected(priority);
        Navigator.pop(context); // Close the dialog after selection
      },
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 10,
      ),
    );
  }
}
