import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  FilterDialog({required this.onApplyFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<String> _selectedStatus = [];
  List<String> _selectedCategories = [];
  List<String> _selectedPriorities = [];
  DateTime? _selectedDueDate;
  List<String> _selectedTags = [];
  String? _selectedDueDateOption; // Track the selected due date option

  final List<String> statusOptions = ['TO DO', 'IN PROGRESS', 'COMPLETE'];
  final List<String> categoryOptions = ['Learning', 'Working', 'General'];
  final List<String> priorityOptions = ['Urgent', 'High', 'Normal', 'Low', 'No Priority'];
  final List<String> tagOptions = ['Project A', 'Project B', 'Project C'];
  final List<String> dueDateOptions = [
    'Select Date',
    'Due Today',
    'Due Tomorrow',
    'Due This Week',
    'Due Next Week',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            children: statusOptions.map((status) {
              return FilterChip(
                label: Text(status),
                selected: _selectedStatus.contains(status),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatus.add(status);
                    } else {
                      _selectedStatus.remove(status);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            children: categoryOptions.map((category) {
              return FilterChip(
                label: Text(category),
                selected: _selectedCategories.contains(category),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Text('Priority Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            children: priorityOptions.map((priority) {
              return FilterChip(
                label: Text(priority),
                selected: _selectedPriorities.contains(priority),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPriorities.add(priority);
                    } else {
                      _selectedPriorities.remove(priority);
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Text('Due Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _selectedDueDateOption,
                hint: Text('Select Due Date'),
                items: dueDateOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDueDateOption = newValue;
                    if (newValue == 'Due Today') {
                      _selectedDueDate = DateTime.now();
                    } else if (newValue == 'Due Tomorrow') {
                      _selectedDueDate = DateTime.now().add(Duration(days: 1));
                    } else if (newValue == 'Due This Week') {
                      _selectedDueDate = _calculateEndOfWeek();
                    } else if (newValue == 'Due Next Week') {
                      _selectedDueDate = _calculateStartOfNextWeek();
                    } else if (newValue == 'Select Date') {
                      _selectDate(context);
                    } else {
                      _selectedDueDate = null;
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Create a map of the selected filters
                Map<String, dynamic> filters = {
                  'status': _selectedStatus.isNotEmpty ? _selectedStatus : null,
                  'categories': _selectedCategories.isNotEmpty ? _selectedCategories : null,
                  'priorities': _selectedPriorities.isNotEmpty ? _selectedPriorities : null,
                  'dueDate': _selectedDueDate,
                  'tags': _selectedTags.isNotEmpty ? _selectedTags : null,
                };
                widget.onApplyFilters(filters);
                Navigator.pop(context);
              },
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  DateTime _calculateEndOfWeek() {
    DateTime now = DateTime.now();
    int daysUntilEndOfWeek = 7 - now.weekday;
    return now.add(Duration(days: daysUntilEndOfWeek));
  }

  DateTime _calculateStartOfNextWeek() {
    DateTime now = DateTime.now();
    int daysUntilNextWeek = 8 - now.weekday;
    return now.add(Duration(days: daysUntilNextWeek));
  }
}
