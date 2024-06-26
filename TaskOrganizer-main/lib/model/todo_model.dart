import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? docID;
  final String assignTo; // Updated field
  final String titleTask;
  final String description;
  final String category;
  final String dateTask;
  final String timeTask;
  final bool isDone;
  final String status;
  final String priority; // New field
  final String tag;   // New field

  TodoModel({
    this.docID,
    required this.assignTo, // assignTo is required
    required this.titleTask,
    required this.description,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.isDone,
    required this.status,
    required this.priority, // New field
    required this.tag, // New field
  });

  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      docID: doc.id,
      assignTo: data['assignTo'] ?? '',
      titleTask: data['titleTask'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      dateTask: data['dateTask'] ?? '',
      timeTask: data['timeTask'] ?? '',
      status: data['status'] ?? '',
      isDone: data['isDone'] ?? false,
      priority: data['priority'] ?? '', // New field
      tag: data['tag'] ?? '', // New field
    );
  }

  // Convert TodoModel instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docID': docID,
      'assignTo': assignTo,
      'titleTask': titleTask,
      'description': description,
      'category': category,
      'dateTask': dateTask,
      'timeTask': timeTask,
      'status': status,
      'isDone': isDone,
      'priority': priority, // New field
      'tag': tag, // New field
    };
  }

  // Create a TodoModel instance from a Map retrieved from Firestore
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      docID: map['docID'] != null ? map['docID'] as String : null,
      assignTo: map['assignTo'] as String, // Ensure assignTo is correctly assigned
      titleTask: map['titleTask'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      dateTask: map['dateTask'] as String,
      timeTask: map['timeTask'] as String,
      isDone: map['isDone'] as bool,
      status: map['status'] as String,
      priority: map['priority'] as String, // New field
      tag: map['tag'] as String, // New field
    );
  }

  // Create a TodoModel instance from a DocumentSnapshot retrieved from Firestore
  factory TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoModel(
      docID: doc.id,
      assignTo: doc['assignTo'] as String, // Ensure assignTo is correctly assigned
      titleTask: doc['titleTask'] as String,
      description: doc['description'] as String,
      category: doc['category'] as String,
      dateTask: doc['dateTask'] as String,
      timeTask: doc['timeTask'] as String,
      isDone: doc['isDone'] as bool,
      status: doc['status'] as String,
      priority: doc['priority'] as String, // New field
      tag: doc['tag'] as String, // New field
    );
  }
}
