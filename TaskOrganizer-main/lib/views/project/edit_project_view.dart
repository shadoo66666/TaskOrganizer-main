import 'package:flutter/material.dart';
import 'package:task_app/widget/projects/project_deteils.dart';

class EditProjectView extends StatelessWidget {
  final String projectId;

  const EditProjectView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ProjectDetailsPage(projectId: projectId),
    );
  }
}
