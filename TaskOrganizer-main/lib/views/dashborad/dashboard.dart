import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart';
import 'package:task_app/widget/common/nav_bar.dart';

class TheDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade900, // Set background color to black
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
                        InkWell(
                          onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NavBar()),
                );
                          },
                          child: Icon(
                            Icons.sort,
                            color: Color.fromARGB(255, 226, 218, 221), // Change icon color to pink
                            size: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.notifications,
                            color: const Color.fromARGB(255, 244, 235, 246), // Change icon color to purple
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white ,// Change text color to yellow
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          "project summary",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white, // Change text color to light blue
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
                    SizedBox(height: 0),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          mainAxisSpacing: 0.5,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          Color backgroundColor;
                          String statusText;
                          int value = 0;
                          switch (index) {
                            case 0:
                              backgroundColor = const Color.fromARGB(255, 222, 142, 169); // Change color to pink
                              statusText = "In Progress";
                              value = 20;
                              break;
                            case 1:
                              backgroundColor = Color.fromARGB(255, 197, 139, 207); // Change color to purple
                              statusText = "In Review";
                              value = 15;
                              break;
                            case 2:
                              backgroundColor = Color.fromARGB(255, 240, 233, 174); // Change color to yellow
                              statusText = "On Hold";
                              value = 10;
                              break;
                            case 3:
                              backgroundColor = Color.fromARGB(255, 155, 208, 233); // Change color to light blue
                              statusText = "Completed";
                              value = 30;
                              break;
                            default:
                              backgroundColor = Colors.grey;
                              statusText = "Unknown";
                          }
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: backgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          statusText,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '$value',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      "Pie Chart Statistics",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Icon(Icons.pie_chart),
                    SizedBox(height: 0),
                    _buildPieChart(context),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Monthly Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '80%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Total Working Hours',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '160',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    Map<String, int> taskData = {
      "In Progress": 20,
      "In Review": 15,
      "On Hold": 10,
      "Completed": 30,
    };

    List<PieChartSectionData> sections = [];

    taskData.forEach((category, count) {
      sections.add(PieChartSectionData(
        color: getCategoryColor(category),
        value: count.toDouble(),
        title: count.toString(),
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnotherPage()),
        );
      },
      child: Container(
        height: 250,
        padding: EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: sections,
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 30,
            sectionsSpace: 0,
          ),
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "In Progress":
        return Color.fromARGB(255, 222, 142, 169); // Pink
      case "In Review":
        return Color.fromARGB(255, 197, 139, 207); // Purple
      case "On Hold":
        return Color.fromARGB(255, 240, 233, 174); // Yellow
      case "Completed":
        return Color.fromARGB(255, 155, 208, 233);// Baby Blue
      default:
        return Colors.grey;
    }
  }
}

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another Page'),
      ),
      body: Center(
        child: Text('This is another page.'),
      ),
    );
  }
}
