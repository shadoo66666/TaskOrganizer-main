import 'package:flutter/material.dart';

class TaskRecommendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Recommend'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.recommend_outlined,
              size: 100, // Larger size for the icon
            ),
            SizedBox(height: 20),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
