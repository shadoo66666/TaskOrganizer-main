import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/widget/halfCircle.dart';
import 'package:task_app/widget/task%20(1)/task/add_new_task.dart';
import 'package:task_app/views/Firebase/firebase_service.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<Map<String, dynamic>> tasks = [];
  String projectName = '';
  String projectOwner = '';
  String projectDescription = '';
  List<String> teamMembers = [];
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

        QuerySnapshot teamSnapshot = await FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .collection('teamMembers')
            .get();
        setState(() {
          teamMembers =
              teamSnapshot.docs.map((doc) => doc['name'] as String).toList();
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
        color: const Color.fromARGB(
            255, 143, 57, 57), // Ensure the entire page has a white background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                // Progress Chart
                Container(
                  height: 250, // زيادة حجم الشارت
                  padding: EdgeInsets.all(16),
                  child: CustomPaint(
                    painter: ProgressChartPainter(
                      inProgress: 0.6,
                      done: 0.3,
                      toDo: 0.1,
                  ),
                  ),
                ),

                Text(
                  projectName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Project Owner: $projectOwner',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Description: $projectDescription',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: Colors.purple,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: teamMembers.map((teamMember) {
                          return Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(teamMember[0].toUpperCase()),
                            ),
                            label: Text(teamMember),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        final newTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNewTaskSheet(userId: _user!.uid)),
                        );
                        if (newTask != null) {
                          addTask(newTask['title']!, newTask['member']!);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                tasks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No tasks available.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      )
                    : Column(
                        children: tasks.map((task) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 239, 228, 240),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title: ${task['title']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Assigned to: ${task['member']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Total tasks: $taskCount',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Completed tasks: $completedTaskCount',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
