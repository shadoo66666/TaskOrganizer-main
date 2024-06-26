import 'package:flutter/material.dart';
import 'package:task_app/widget/projects/project_deteils.dart';
import 'package:task_app/widget/task%20(1)/task/add_new_task.dart';
// استيراد الصفحة المناسبة هنا

class EditProjectViewBody extends StatefulWidget {
  final String projectId;

  const EditProjectViewBody({super.key, required this.projectId});

  @override
  _EditProjectViewBodyState createState() => _EditProjectViewBodyState();
}

class _EditProjectViewBodyState extends State<EditProjectViewBody> {
  List<Map<String, String>> tasks = [];

  void addTask(String title, String member) {
    setState(() {
      tasks.add({'title': title, 'member': member});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks Details',
          style: TextStyle(color: Color.fromARGB(255, 175, 97, 180)),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Web Development',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 223, 171, 235),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Icon(
                    Icons.date_range,
                    color: Color.fromARGB(255, 69, 12, 79),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '28 March, at 11:30 am',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'In Progress',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '65%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: 0.65,
                color: Color.fromARGB(255, 51, 16, 61),
                backgroundColor: Color.fromARGB(255, 237, 182, 244),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'The project will incorporate several popular web development technologies. Much of the time, the tools and programming languages taught in a classroom setting are learned and practice in isolation from one another....',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  // Add your logic to expand the overview section
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 210, 125, 227),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          final newTask = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddNewTaskSheet(userId: widget.projectId, )),
                          );
                          if (newTask != null) {
                            addTask(newTask['title']!, newTask['member']!);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  tasks.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No tasks available.',
                            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5)),
                          ),
                        )
                      : Column(
                          children: tasks.map((task) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 239, 228, 240),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title: ${task['title']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Assigned to: ${task['member']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
