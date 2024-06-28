import 'package:flutter/material.dart';

import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.grey.shade900, // Background color of AppBar
      ),
      body: Container(
        color: Colors.grey.shade900, // Set background color to black
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.sort,
                            color: Color(0xffE2DADA), // Change icon color to light pink
                            size: 40,
                          ),
                          Icon(
                            Icons.notifications,
                            color: Color(0xffF4EBF6), // Change icon color to light purple
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white, // Change text color to white
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            "project summary",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff81D4FA), // Change text color to light blue
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Your existing content here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
