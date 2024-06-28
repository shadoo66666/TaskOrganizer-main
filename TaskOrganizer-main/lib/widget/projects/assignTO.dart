import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewTaskSheet extends StatefulWidget {
  final String projectId;
  final List<String> teamMembers;

  const AddNewTaskSheet({Key? key, required this.projectId, required this.teamMembers}) : super(key: key);

  @override
  _AddNewTaskSheetState createState() => _AddNewTaskSheetState();
}

class _AddNewTaskSheetState extends State<AddNewTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';
  String? _selectedMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _taskTitle = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Assign to'),
                items: widget.teamMembers.map((String member) {
                  return DropdownMenuItem<String>(
                    value: member,
                    child: Text(member),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMember = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a team member';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveTask();
                  }
                },
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _taskTitle,
        'member': _selectedMember,
        'projectId': widget.projectId,
        'status': 'incomplete',
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error saving task: $e');
    }
  }
}
