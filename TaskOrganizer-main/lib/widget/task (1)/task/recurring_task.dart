import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task_app/constants/app_style.dart';

class TaskOptionsDialog extends StatefulWidget {
  final String selectedRecurring;
  final bool skipWeekends;
  final int daysAfter;
  final void Function(String?) onRecurringChanged;
  final void Function(bool) onSkipWeekendsChanged;
  final void Function(int) onDaysAfterChanged;

  const TaskOptionsDialog({
    Key? key,
    required this.selectedRecurring,
    required this.skipWeekends,
    required this.daysAfter,
    required this.onRecurringChanged,
    required this.onSkipWeekendsChanged,
    required this.onDaysAfterChanged,
  }) : super(key: key);

  @override
  _TaskOptionsDialogState createState() => _TaskOptionsDialogState();
}

class _TaskOptionsDialogState extends State<TaskOptionsDialog> {
  late String _selectedOption;
  late bool _skipWeekends;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedRecurring;
    _skipWeekends = widget.skipWeekends;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Recurring'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
                widget.onRecurringChanged(value);
              });
            },
            items: <String>[
              'No Recurring', // Add 'No Recurring' option
              'Daily',
              'Weekly',
              'Monthly',
              'Yearly',
              'Days After',
              'Custom',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (_selectedOption == 'Days After') ...[
            const Gap(12),
            _buildDaysAfterInput(),
          ],
          const Gap(12),
          const Text('Other Options', style: AppStyle.headingOne),
          const Gap(6),
          Row(
            children: [
              Text('Skip Weekends'),
              const Spacer(),
              Switch(
                value: _skipWeekends,
                onChanged: (value) {
                  setState(() {
                    _skipWeekends = value;
                    widget.onSkipWeekendsChanged(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildDaysAfterInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Days After'),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.onDaysAfterChanged(int.tryParse(value) ?? 0);
          },
        ),
        const Gap(12),
      ],
    );
  }
}
