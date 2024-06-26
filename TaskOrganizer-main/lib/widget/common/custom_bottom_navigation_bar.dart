import 'package:flutter/material.dart';
import 'package:task_app/chat%20(2)/chat/chat_page.dart';

import 'package:task_app/views/home_screen.dart';
import 'package:task_app/views/task/all_task_screen%20(1).dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:task_app/widget/inbox.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  
  List<IconData> iconList = [ 
    Icons.home,
    Icons.checklist_rounded,
    Icons.inbox,
    Icons.chat
  ];
  // default index of the tabs 
  int _currentIndex = 0; 
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      activeIndex: _currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      onTap: (newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
    
    // Navigate to a new page based on the selected index
    switch (newIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllTaskScreen()),
        );
        break;
        case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InboxPage()),
        );
        break;
        case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ChatPage()),
        );
        break;
        }},
        
backgroundColor: const Color(0xff8145E5), );
  }
}

