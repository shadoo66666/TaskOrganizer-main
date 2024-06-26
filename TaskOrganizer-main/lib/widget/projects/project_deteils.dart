import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:task_app/views/Firebase/firebase_service.dart';
import 'package:task_app/widget/task%20(1)/task/add_new_task.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({Key? key, required this.projectId}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<Map<String, dynamic>> tasks = [];
  String projectName = '';
  String projectOwner = '';
  String projectDescription = '';
  List<String> teamMembers = [];
  List<String> teamMemberNames = [];
  int taskCount = 0;
  int completedTaskCount = 0;

  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProjectData();
    _fetchTasks();
  }

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  Future<void> _fetchProjectData() async {
    try {
      DocumentSnapshot projectSnapshot =
          await FirebaseService().getProjectById(widget.projectId);
      if (projectSnapshot.exists) {
        setState(() {
          projectName = projectSnapshot['name'];
          projectDescription = projectSnapshot['description'];
        });
        String adminName = await FirebaseService()
            .getAdminNameById(projectSnapshot['adminId']);
        setState(() {
          projectOwner = adminName;
        });

        // Fetch team members
        List<dynamic> memberEmails = projectSnapshot['teamMembers'];
        List<String> usernames = [];

        for (String email in memberEmails) {
          Map<String, dynamic>? userData = await FirebaseService().getUserByEmail(email);
          if (userData != null) {
            usernames.add(userData['username']);
          }
        }

        setState(() {
          teamMembers = List<String>.from(memberEmails);
          teamMemberNames = usernames;
        });
      }
    } catch (e) {
      print('Error fetching project data: $e');
    }
  }

  void _fetchTasks() async {
    try {
      QuerySnapshot taskSnapshot =
          await FirebaseService().getTasksByProjectId(widget.projectId);
      List<Map<String, dynamic>> loadedTasks = taskSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {
        tasks = loadedTasks;
        taskCount = tasks.length;
        completedTaskCount =
            tasks.where((task) => task['status'] == 'completed').length;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void addTask(String title, String member) {
    setState(() {
      tasks.add({'title': title, 'member': member});
      taskCount++;
    });
  }

  /// Returns an icon based on the first letter of the member's name
  IconData _getIconForName(String name) {
    // Using a simple switch-case for demonstration purposes
    switch (name[0].toUpperCase()) {
      case 'A':
        return Icons.all_inclusive;
      case 'B':
        return Icons.bug_report;
      case 'C':
        return Icons.child_care;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 100,
                            lineWidth: 10,
                            percent: taskCount == 0 ? 0 : completedTaskCount / taskCount,
                            center: Text(
                              taskCount == 0
                                  ? '0%'
                                  : '${((completedTaskCount / taskCount) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            progressColor: Color.fromARGB(255, 185, 86, 175),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Project Progress',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projectDescription,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Colors.purple,
                  ),
                  title: Text(
                    'Team Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: teamMemberNames.map((member) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          _getIconForName(member),
                          color: const Color.fromARGB(255, 127, 34, 34),
                        ),
                        backgroundColor: Colors.purple,
                      ),
                      title: Text(
                        member, // Displaying member username
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    tasks.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tasks available.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          )
                        : Column(
                            children: tasks.map((task) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.purple[50],
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task['title'] ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            task['member'] ?? 'No Member Assigned',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        task['status'] == 'completed'
                                            ? Icons.check_circle
                                            : Icons.circle,
                                        color: task['status'] == 'completed'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                 AddNewTaskSheet(userId: widget.projectId), // Pass userId
                            ),
                          ).then((_) {
                            _fetchTasks();
                          });
                        },
                        child: const Text('Add New Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
