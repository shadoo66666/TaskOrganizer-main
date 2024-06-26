import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to sign up a user with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password); 
      User? user = credential.user;

      if (user != null) {
        // Store additional user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': email,
          'username': username,
          'password': password,
          // Add other user fields here
        });

        // Update user profile with username
        await user.updateDisplayName(username);
      }

      return user; // Return the created user
    } catch (e) {
      // If an error occurs during registration, print the error and return null
      print("Error occurred during registration: $e");
      return null;
    }
  }

  // Method to log in a user with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in user with email and password
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
        print("User Data: ${userData.data()}");
      }

      return user; // Return the logged-in user
    } catch (e) {
      // If an error occurs during login, print the error and return null
      print("Error occurred during login: $e");
      return null;
    }
  }

  // Method to update user profile with username
  Future<void> updateUserProfile(String username) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Update display name of the current user with the provided username
        await currentUser.updateDisplayName(username);
        
        // Update username in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'username': username,
        });
      } else {
        // If no user is signed in, print a message
        print('No user is currently signed in');
      }
    } catch (e) {
      // If an error occurs during profile update, print the error
      print('Error updating user profile: $e');
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc;
  }

  Future<List<Map<String, dynamic>>> getUserTasks(String uid) async {
    try {
      QuerySnapshot tasksSnapshot = await _firestore.collection('tasks').where('userId', isEqualTo: uid).get();
      List<Map<String, dynamic>> tasks = tasksSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return tasks;
    } catch (e) {
      print("Error getting user tasks: $e");
      return [];
    }
  }
}
