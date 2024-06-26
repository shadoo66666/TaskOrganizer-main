import 'package:flutter/material.dart';
import 'package:task_app/views/firebaseauth1.dart'; // Import your FirebaseAuthService
import 'package:task_app/views/home_screen.dart'; // Import your HomeScreen
import 'package:task_app/widget/logIn/my_button.dart'; // Import your custom button widget
import 'package:task_app/widget/logIn/my_textfield.dart'; // Import your custom text field widget
import 'package:task_app/widget/logIn/square_tile.dart'; // Import your custom square tile widget

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instance of your FirebaseAuthService

  bool isLoading = false; // Flag to track loading state

  void signUp(BuildContext context) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    // Get user input from text controllers
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;

    // Perform sign up with Firebase Authentication
    var user = await _authService.signUpWithEmailAndPassword(email, password, username);
    if (user != null) {
      // Update user profile with username
      await _authService.updateUserProfile(username);
      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show error message if sign up fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Sign up failed. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    setState(() {
      isLoading = false; // Set loading state to false after sign up process
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set background color
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Spacer
                const Icon(
                  Icons.person_add, // Icon for sign up
                  size: 100,
                   color: Colors.black,
                ),
                const SizedBox(height: 50), // Spacer
                Text(
                  'Create an Account', // Title for sign up
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25), // Spacer
                MyTextField(
                  controller: usernameController, // Username text field
                  hintText: 'Username', // Placeholder text
                  obscureText: false, // Not an obscured text field
                ),
                const SizedBox(height: 10), // Spacer
                MyTextField(
                  controller: emailController, // Email text field
                  hintText: 'Email', // Placeholder text
                  obscureText: false, // Not an obscured text field
                ),
                const SizedBox(height: 10), // Spacer
                MyTextField(
                  controller: passwordController, // Password text field
                  hintText: 'Password', // Placeholder text
                  obscureText: true, // Obscured text field
                ),
                const SizedBox(height: 25), // Spacer
                isLoading
                    ? CircularProgressIndicator() // Show loading indicator if isLoading is true
                    : MyButton(
                        onTap: () => signUp(context), // Callback function for sign up button
                        text: 'Sign Up', // Text for sign up button
                      ),
                const SizedBox(height: 50), // Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/google.png'), // Google sign in option
                    SizedBox(width: 25), // Spacer
                    SquareTile(imagePath: 'assets/images/apple.png'), // Apple sign in option
                  ],
                ),
                const SizedBox(height: 50), // Spacer
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to the login page
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?', // Text for login prompt
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4), // Spacer
                      Text(
                        'Log In', // Text for login navigation
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
