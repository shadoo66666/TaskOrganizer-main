import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:task_app/views/Firebase/firebase_service.dart';
import 'package:task_app/widget/task%20(1)/task/add_new_task.dart';
import 'package:task_app/views/app_colors.dart';

const Color primary = Color(0xff3889C9);
const Color orange = Color(0xffE29C6E);

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
    _generateMemberIcons();
  }

  List<Widget> memberIcons = [];
  List<String> userImages = [
    'TaskOrganizer-main/assets/images/raste/ظavatar-1.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-2.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-3.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-4.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-5.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-6.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-7.png',
    'TaskOrganizer-main/assets/images/raste/ظavatar-8.png',
    // Add more images here for additional members
  ];

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

        List<dynamic> memberEmails = projectSnapshot['teamMembers'];
        List<String> usernames = [];

        for (String email in memberEmails) {
          Map<String, dynamic>? userData =
              await FirebaseService().getUserByEmail(email);
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
      tasks.add({'title': title, 'member': member, 'status': 'pending'});
      taskCount++;
    });
  }

  /// Returns an icon based on the first letter of the member's name
  void _generateMemberIcons() {
    memberIcons.clear(); // Clear existing icons to avoid duplicates

    for (int i = 0; i < teamMembers.length; i++) {
      String imagePath = userImages[i % userImages.length]; // Assuming userImages is a list of image paths
      memberIcons.add(
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: orange, // Orange background color
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(imagePath), // Use AssetImage for local images
            radius: 12,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectName,
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff3889C9),
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
                            percent: taskCount == 7? 5: completedTaskCount / taskCount,
                            center: Text(
                              '50%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            progressColor: Color(0xffE29C6E),
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
                    color: Color(0xff3889C9),
                  ),
                  title: Text(
                    'Team Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3889C9),
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
                    String imagePath = userImages[
                        teamMemberNames.indexOf(member) % userImages.length];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(imagePath),
                        radius: 20,
                        child: Text(member[0].toUpperCase()),
                      ),
                      title: Text(
                        member,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.7)),
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
                          color: primary),
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
                                    color: Color(0xff3889C9).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity
(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task['title'] ?? 'Untitled',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            task['member'] ?? 'Unassigned',
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
                                            ? Color.fromARGB(255, 80, 83, 80)
                                            : Color.fromARGB(255, 91, 89, 89),
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
                                           AddNewTaskSheet(userId: widget.projectId),
                            
                            ),
                          ).then((_) {
                            _fetchTasks();
                          });
                        },
                        child: const Text('Add New Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff3889C9),
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

class AddNewTaskSheet extends StatefulWidget {
  final String userId;

  const AddNewTaskSheet({Key? key, required this.userId}) : super(key: key);

  @override
  _AddNewTaskSheetState createState() => _AddNewTaskSheetState();
}

class _AddNewTaskSheetState extends State<AddNewTaskSheet> {
  String taskTitle = '';
  TextEditingController assignToController = TextEditingController();

  @override
  void dispose() {
    assignToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Color(0xff3889C9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => taskTitle = value,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assign To',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: assignToController,
              decoration: InputDecoration(
                hintText: 'Enter member name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String selectedMember = assignToController.text.trim();
                if (taskTitle.isNotEmpty && selectedMember.isNotEmpty) {
                  FirebaseService().addTaskToProject(
                    widget.userId,
                    taskTitle,
                    selectedMember,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Task'),
              style: ElevatedButton.styleFrom(
                iconColor: Color(0xff3889C9),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
