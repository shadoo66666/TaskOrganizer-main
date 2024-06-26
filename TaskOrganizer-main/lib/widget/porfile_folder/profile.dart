import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/widget/porfile_folder/textBoxPro.dart';
import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';
import 'package:task_app/widget/task%20(1)/task/add_task_button.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  //editfield
  Future<void> editfield(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('PROFILE', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 239, 139, 172),
      ),
      body: currentUser != null
          ? ListView(
              children: [
                const SizedBox(height: 50),
                // Profile picture
                Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
                // User email
                Text(
                  currentUser!.email ?? 'No email available',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                // User details
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Text boxes for username and email
                textBOXS(
                  text: 'Username',
                  sectionName: 'username',
                  onPressed: () => editfield('username'),
                ),
                textBOXS(
                  text: 'Email',
                  sectionName: 'email',
                  onPressed: () => editfield('email'),
                ),
                // Placeholder for bio and phone number text boxes
                textBOXS(
                  text: 'Bio',
                  sectionName: 'bio',
                  onPressed: () => editfield('bio'),
                ),
                textBOXS(
                  text: 'Phone Number',
                  sectionName: 'phone',
                  onPressed: () => editfield('phone'),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
      //floatingActionButton: const AddTaskButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
