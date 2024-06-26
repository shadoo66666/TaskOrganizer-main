import 'package:flutter/material.dart';
import 'package:task_app/views/Firebase/firebase_service.dart'; // تأكد من استيراد المكتبة الصحيحة

class UsernameByEmailPage extends StatefulWidget {
  final String email;

  const UsernameByEmailPage({Key? key, required this.email}) : super(key: key);

  @override
  _UsernameByEmailPageState createState() => _UsernameByEmailPageState();
}

class _UsernameByEmailPageState extends State<UsernameByEmailPage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      Map<String, dynamic>? userData = await FirebaseService().getUserByEmail(widget.email);
      if (userData != null) {
        setState(() {
          username = userData['username'];
        });
      } else {
        setState(() {
          username = 'المستخدم غير موجود';
        });
      }
    } catch (e) {
      print('Error fetching username: $e');
      setState(() {
        username = 'حدث خطأ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اليوزرنيم من البريد الإلكتروني'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (username != null)
              Text(
                'اليوزرنيم: $username',
                style: TextStyle(fontSize: 20),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }
}

