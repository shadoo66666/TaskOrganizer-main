import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatefulWidget {
  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  Map<String, dynamic> projectData = {};

  @override
  void initState() {
    super.initState();
    loadProjectData();
  }

  Future<void> loadProjectData() async {
    Map<String, dynamic> data = await getProjectData();
    setState(() {
      projectData = data;
    });
  }

  Future<Map<String, dynamic>> getProjectData() async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> projectData = {};

    if (user != null) {
      try {
        // استعلام قاعدة البيانات لجلب بيانات المشروع
        DocumentSnapshot projectDoc =
            await FirebaseFirestore.instance.collection('projects').doc(user.uid).get();

        if (projectDoc.exists) {
          projectData = projectDoc.data() as Map<String, dynamic>;
        } else {
          print('Project document does not exist');
        }
      } catch (e) {
        print('Error fetching project data: $e');
      }
    } else {
      print('User is not logged in');
    }

    return projectData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
      ),
      body: Center(
        child: projectData.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Project ID: ${projectData['projectId']}'),
                  Text('Project Name: ${projectData['projectName']}'),
                  Text('Admin ID: ${projectData['adminId']}'), // عرض adminId هنا
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
