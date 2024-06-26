import 'package:flutter/material.dart';


enum Priority {
  low,
  medium,
  high,
}

// class AddBtnProject extends StatelessWidget {
//   const AddBtnProject({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Colors.purple,
//         hintColor: const Color.fromARGB(255, 191, 137, 235),
//         textTheme: const TextTheme(
//           titleLarge: TextStyle(
//             fontFamily: 'Pacifico',
//             fontSize: 24,
//             color: Colors.white,
//           ),
//           bodyLarge: TextStyle(
//             fontSize: 16,
//           ),
//         ),
//       ),
//       home: const ActionBtn(),
//     );
//   }
// }

// class ActionBtn extends StatelessWidget {
//   const ActionBtn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return const AddbtnSheett();
//             },
//           );
//         },
//         label: const Text('New Project'),
//         icon: const Icon(
//           Icons.add,
//         ),
//       ),
//     );
//   }
// }

class AddbtnSheett extends StatefulWidget {
  const AddbtnSheett({super.key});

  @override
  _AddbtnSheettState createState() => _AddbtnSheettState();
}

class _AddbtnSheettState extends State<AddbtnSheett> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _selectedFriends = [];
  String _projectName = '';

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _projectNameController,
            onChanged: (value) {
              setState(() {
                _projectName = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.bolt),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 1,
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Project Description',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.assignment_outlined),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              _selectDateTime(context);
            },
            child: IgnorePointer(
              child: TextField(
                controller: _dateTimeController,
                decoration: const InputDecoration(
                  labelText: 'Select Deadline',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.edit_calendar_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _selectFriends(context);
            },
            child: const Text('Invite your team members'),
          ),
          const SizedBox(height: 16),
          if (_selectedFriends.isNotEmpty)
            Wrap(
              children: _selectedFriends.map((member) {
                return Chip(
                  label: Text(member),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      _selectedFriends.remove(member);
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cancel
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_projectName.isEmpty || _selectedFriends.isEmpty) {
                    _showErrorMessage(context);
                  } else {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TasksPage(selectedTeamMembers: _selectedFriends),
                    ));
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _dateTimeController.text =
              '${_selectedDate!.toString().split(' ')[0]} ${_selectedTime!.format(context)}';
        });
      }
    }
  }

  Future<void> _selectFriends(BuildContext context) async {
    final List<String>? selectedFriends = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Team Members'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildFriendCheckbox('Member 1'),
                _buildFriendCheckbox('Member 2'),
                _buildFriendCheckbox('Member 3'),
                // Add more friends here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedFriends); // Continue
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (selectedFriends != null && selectedFriends.isNotEmpty) {
      setState(() {
        _selectedFriends = List.from(selectedFriends);
      });
    }
  }

  Widget _buildFriendCheckbox(String friend) {
    return CheckboxListTile(
      title: Text(friend),
      value: _selectedFriends.contains(friend),
      onChanged: (bool? value) {
        setState(() {
          if (value != null && value) {
            _selectedFriends.add(friend);
          } else {
            _selectedFriends.remove(friend);
          }
        });
      },
    );
  }

  void _showErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Please enter the project name and team members.',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TasksPage extends StatefulWidget {
  final List<String> selectedTeamMembers;

  const TasksPage({super.key, required this.selectedTeamMembers});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<String> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskPage(
        selectedTeamMembers: widget.selectedTeamMembers,
        onTaskAdded: (task, member) {
          setState(() {
            _tasks.add(task);
          });
        },
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  final Function(String, String) onTaskAdded;
  final List<String> selectedTeamMembers;

  const AddTaskPage({super.key, required this.onTaskAdded, required this.selectedTeamMembers});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  Priority? _selectedPriority;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedMember = '';

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _taskNameController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.bolt),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.assignment_outlined),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _selectDeadline(context);
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: _deadlineController,
                    decoration: const InputDecoration(
                      labelText: 'Deadline',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.edit_calendar_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _selectPriority(context);
                      },
                      child: const Text('Select Priority'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _memberController,
                readOnly: true,
                onTap: () {
                  _selectMember(context);
                },
                decoration: const InputDecoration(
                  labelText: 'Assign To',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addTask();
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _deadlineController.text =
              '${_selectedDate!.toString().split(' ')[0]} ${_selectedTime!.format(context)}';
        });
      }
    }
  }

  Future<void> _selectPriority(BuildContext context) async {
    final Priority? selectedPriority = await showDialog<Priority>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Priority.values.map((priority) {
              return RadioListTile<Priority>(
                title: Text(
                  priority.toString().split('.').last,
                  style: TextStyle(
                    color: _getColorForPriority(priority),
                  ),
                ),
                value: priority,
                groupValue: _selectedPriority,
                onChanged: (Priority? value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                  Navigator.of(context).pop(value);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedPriority != null) {
      setState(() {
        _selectedPriority = selectedPriority;
      });
    }
  }

  Future<void> _selectMember(BuildContext context) async {
    final String? selectedMember = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Task To'),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.selectedTeamMembers.map((member) {
                return ListTile(
                  title: Text(member),
                  onTap: () {
                    Navigator.of(context).pop(member);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedMember != null) {
      setState(() {
        _selectedMember = selectedMember;
        _memberController.text = selectedMember;
      });
    }
  }

  void _addTask() {
    String taskName = _taskNameController.text.trim();
    String description = _descriptionController.text.trim();
    String deadline = _deadlineController.text.trim();

    if (taskName.isNotEmpty && _selectedPriority != null && deadline.isNotEmpty && _selectedMember.isNotEmpty) {
      widget.onTaskAdded('$taskName - ${_selectedPriority.toString().split('.').last} - $description - Deadline: $deadline', _selectedMember);
      Navigator.of(context).pop(); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter task name, select priority, assign to a member, and choose a deadline'),
        ),
      );
    }
  }
}

Color _getColorForPriority(Priority priority) {
  switch (priority) {
    case Priority.low:
      return Colors.green;
    case Priority.medium:
      return Colors.yellow;
    case Priority.high:
      return Colors.red;
    default:
      return Colors.black;
  }
}