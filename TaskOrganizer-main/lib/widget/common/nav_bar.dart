import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/views/dashborad/dashboard.dart';
import 'package:task_app/views/project/projects_view.dart';
import 'package:task_app/views/task/all_task_screen%20(1).dart';
import 'package:task_app/views/task_recommend/RecommendPage.dart';
import 'package:task_app/widget/Calendar.dart';
import 'package:task_app/widget/common/logout.dart';
import 'package:task_app/widget/porfile_folder/profile.dart';
import '../../views/settings_page.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  _userData?['username'] ?? 'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  _userData?['email'] ?? 'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: _userData != null && _userData!['profileImage'] != null
                      ? NetworkImage(_userData!['profileImage'])
                      : null,
                  child: _userData == null || _userData!['profileImage'] == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.checklist_rtl, color: Colors.white),
              title: Text('Your Tasks', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllTaskScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.ballot_outlined, color: Colors.white),
              title: Text('Your Projects', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProjectsView()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.date_range_rounded, color: Colors.white),
              title: Text('Calendar', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.white),
              title: Text('Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TheDashboard()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.recommend_outlined, color: Colors.white),
              title: Row(
                children: [
                  Text('Task Recommend', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 10),
                  Container(
                    width: 1,
                    color: Colors.grey,
                    height: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'soon',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskRecommendPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Log Out', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              onTap: () {
                LogoutPage.showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
