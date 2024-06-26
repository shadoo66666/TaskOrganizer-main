import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};

  if (user != null) {
    try {
      // استعلام قاعدة البيانات لجلب معلومات المستخدم
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
        // تعيين adminId إلى قيمة UID للمستخدم الحالي، إذا كان المستخدم يدير مشروعًا
        if (userData['role'] == 'admin' && userData['projectId'] != null) {
          userData['adminId'] = userData['projectId']; // أو يمكنك تعيين القيمة بطريقة تناسب بنيتك
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  } else {
    print('User is not logged in');
  }

  return userData;
}


class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> data = await getUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // يمكنك إضافة رسالة خطأ للمستخدم هنا
      print('Failed to load user data: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // بعد تسجيل الخروج، قم بإعادة التوجيه للشاشة التي تحتاج إلى تسجيل الدخول
      // يمكنك استخدام Navigator.pushReplacement أو إعادة توجيه إلى شاشة تسجيل الدخول
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : userData.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('User ID: ${userData['id']}'),
                      Text('Username: ${userData['username']}'),
                    ],
                  )
                : Text('No user data available'),
      ),
    );
  }
}
