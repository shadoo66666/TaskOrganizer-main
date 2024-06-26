import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/model/todo_model.dart';
import 'package:task_app/services/todo_service.dart';

final serviceProvider = StateProvider<TodoService>((ref) {
  return TodoService();
});
final userTasksProvider = StreamProvider<List<TodoModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  final String? userId = currentUser?.uid;

  if (userId != null) {
    CollectionReference tasksCollection = FirebaseFirestore.instance.collection('todoApp');

    Stream<QuerySnapshot> querySnapshotStream = tasksCollection
        .where('userId', isEqualTo: userId)
        .snapshots();

    return querySnapshotStream.map((querySnapshot) =>
        querySnapshot.docs.map((doc) => TodoModel.fromFirestore(doc)).toList());
  } else {
    return Stream.value([]); // Return an empty list if userId is null
  }
});