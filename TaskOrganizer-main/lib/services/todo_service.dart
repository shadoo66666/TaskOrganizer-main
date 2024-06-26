import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/model/todo_model.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection('todoApp');

  //create
  void addNewTask(TodoModel model) async {
  DocumentReference docRef = await todoCollection.add(model.toMap());
     // Update the document with its own ID
    await docRef.update({'docID': docRef.id});
  }

  //update
  void updateTask(String? docID, bool? valueUpdate) {
    todoCollection.doc(docID).update({'isDone': valueUpdate});
  }

  //delete
  void deleteTask(String? docID) {
    todoCollection.doc(docID).delete();
  }
}
