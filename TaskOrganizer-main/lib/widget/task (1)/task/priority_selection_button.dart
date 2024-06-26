import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:task_app/widget/task%20(1)/task/priority_widget.dart';


class PrioritySelectionButton extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPrioritySelected;

  const PrioritySelectionButton({
    Key? key, // Add Key here
    required this.selectedPriority,
    required this.onPrioritySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPriorityDialog(context),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            color: getPriorityColor(selectedPriority),
          ),
          const Gap(9),
          Text(
            selectedPriority != 'No Priority' ? selectedPriority : 'Add Priority',
            style: TextStyle(
              fontSize: 18,
                  fontWeight: FontWeight.w700,

              color: selectedPriority != 'No Priority' ? getPriorityColor(selectedPriority) : Colors.white, // Set black color if priority is 'No Priority'
            ),
          ),
        ],
      ),
    );
  }

  void _showPriorityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PrioritySelectionDialog(
        onPrioritySelected: onPrioritySelected,
      ),
    );
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Normal':
        return Colors.blue;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
