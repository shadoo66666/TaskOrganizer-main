import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:task_app/model/todo_model.dart';
import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';
import 'package:task_app/provider/service_provider.dart';
import 'package:task_app/widget/task%20(1)/task/FilterDialog.dart';
import 'package:task_app/widget/task%20(1)/task/card_todo_list_widget.dart';

class AllTaskScreen extends ConsumerStatefulWidget {
  const AllTaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends ConsumerState<AllTaskScreen> {
  Map<String, dynamic> _filters = {};

  @override
  Widget build(BuildContext context) {

    // Fetch tasks for the logged-in user
    AsyncValue<List<TodoModel>> todoData = ref.watch(userTasksProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8145E5),
        title: const Text('All Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 13),
            ElevatedButton(
              onPressed: () {
                _showFilterDialog(context);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.filter),
                  SizedBox(width: 8), // Added space between icon and text
                  Text('Filters'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: todoData.when(
                data: (tasks) {
                  // Apply filters to the tasks
                  final filteredTasks = tasks.where((task) {
  // Check if task matches each filter condition
  bool matchesStatus = _filters['status'] == null || _filters['status'].contains(task.status);
  bool matchesCategories = _filters['categories'] == null || _filters['categories'].contains(task.category);
  bool matchesPriorities = _filters['priorities'] == null || _filters['priorities'].contains(task.priority);
  bool matchesDueDate = _filters['dueDate'] == null || task.dateTask == _filters['dueDate'];
  bool matchesTags = _filters['tags'] == null || task.tag.contains(_filters['tags']);

  // Combine all filter conditions using &&
  return matchesStatus && matchesCategories && matchesPriorities && matchesDueDate && matchesTags;
}).toList();

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) => CardTodoListWidget(task: filteredTasks[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterDialog(
          onApplyFilters: (filters) {
            setState(() {
              _filters = filters;
              print(_filters); // Add this line to check if filters are applied correctly
            });
          },
        );
      },
    );
  }
}