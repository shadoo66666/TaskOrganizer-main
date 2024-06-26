import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_app/views/Firebase/firebase_service.dart';
import 'package:task_app/views/project/edit_project_view.dart';
import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';
import 'package:task_app/widget/common/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/views/Firebase/firebase_service.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({Key? key}) : super(key: key);

  @override
  _ProjectsViewState createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  void _refreshProjects() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(237, 227, 232, 227),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProjectView(onProjectAdded: _refreshProjects),
            ),
          );
        },
        label: const Text('New Project'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 8),
          Expanded(
            child: ProjectsListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavBar()),
              );
            },
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(width: 8),
          Text(
            'Projects',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Handle search button press
            },
            icon: const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  final String projectId;
  final String projectName;
  final String projectDescription;
  final String projectDeadline;

  const ProjectItem({
    required this.projectId,
    required this.projectName,
    required this.projectDescription,
    required this.projectDeadline,
    Key? key,
  }) : super(key: key);

  void _deleteProject(BuildContext context) {
    try {
      // استدعاء خدمة Firebase لحذف المشروع بواسطة معرفه
      // FirebaseService().deleteProject(projectId);

      // إعادة تحميل قائمة المشاريع بعد الحذف
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project deleted successfully')),
      );
    } catch (e) {
      print('Error deleting project: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete project')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProjectView(projectId: projectId)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 254, 253, 252),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                projectName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  projectDescription,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.date_range,
                    color: Color.fromARGB(255, 69, 12, 79),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    projectDeadline,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteProject(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularPercentIndicator(
                radius: 40,
                lineWidth: 8,
                percent: 0.5,
                center: Text(
                  '50%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: Color.fromARGB(255, 197, 204, 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsListView extends StatelessWidget {
  const ProjectsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Map<String, dynamic>> projects = snapshot.data ?? [];

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: projects.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> project = projects[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ProjectItem(
                projectId: project['id'] ?? '',
                projectName: project['name'] ?? 'Project Name',
                projectDescription: project['description'] ?? 'Project Description',
                projectDeadline: project['deadline'] ?? 'Deadline',
              ),
            );
          },
        );
      },
    );
  }
}



class AddProjectView extends StatefulWidget {
  final VoidCallback onProjectAdded;

  const AddProjectView({Key? key, required this.onProjectAdded}) : super(key: key);

  @override
  _AddProjectViewState createState() => _AddProjectViewState();
}

class _AddProjectViewState extends State<AddProjectView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _emailController = TextEditingController();
  List<String> teamMembers = [];
  List<String> searchResults = [];
  bool emailNotFound = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _saveProject() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final deadline = _deadlineController.text;

      try {
        await FirebaseService().addProject(
          name: name,
          description: description,
          deadline: deadline,
          projectTasks: [],
          teamMembers: teamMembers,
          adminId: 'adminId', // Replace with actual admin ID
        );

        widget.onProjectAdded();
        Navigator.pop(context);
      } catch (e) {
        print('Error saving project: $e');
      }
    }
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
              '${_selectedDate.toString().split(' ')[0]} ${_selectedTime.format(context)}';
        });
      }
    }
  }

  void _addTeamMember(String email) {
    setState(() {
      if (!teamMembers.contains(email)) {
        teamMembers.add(email);
        _emailController.clear();
        searchResults.clear(); // Clear search results after adding
      } else {
        // Handle case where email is already added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already added to team members')),
        );
      }
    });
  }

  Future<void> _searchEmail(String email) async {
    if (email.isNotEmpty) {
      try {
        final result = await FirebaseFirestore.instance
            .collection('users') // Replace 'users' with your collection name
            .where('email', isGreaterThanOrEqualTo: email)
            .where('email', isLessThan: email + 'z')
            .get();

        setState(() {
          searchResults.clear();
          result.docs.forEach((doc) {
            searchResults.add(doc['email']);
          });
          if (searchResults.isEmpty) {
            emailNotFound = true;
          } else {
            emailNotFound = false;
          }
        });
      } catch (e) {
        print('Error searching email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the project name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Project Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the project description';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Team Member Email'),
                onChanged: _searchEmail,
                validator: (value) {
                  return null;
                },
              ),
              if (searchResults.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Search Results:'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchResults[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _addTeamMember(searchResults[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              if (emailNotFound)
                Text('Email not found in database'),
              Wrap(
                children: teamMembers
                    .map(
                      (email) => Chip(
                        label: Text(email),
                        onDeleted: () {
                          setState(() {
                            teamMembers.remove(email);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProject,
                child: Text('Save Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
