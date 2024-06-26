import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TextEditingController _taskNameController;
  late TimeOfDay _selectedTime;
  bool _isTaskAddingVisible = false;
  bool _isTimeSelected = false;
  Map<DateTime, Color> _taskColors = {}; // Store colors for each day with a task

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _taskNameController = TextEditingController();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _isTaskAddingVisible = true; // Show task addition when a day is selected
              });
            },
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, events) {
                final color = _taskColors[date] ?? Theme.of(context).primaryColor;
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          if (_isTaskAddingVisible) // Conditionally show task addition
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Task:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _selectedTime = selectedTime;
                          _isTimeSelected = true;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          'Select Time: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (_isTimeSelected)
                          Text(
                            '${_selectedTime.format(context)}',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          )
                        else
                          Text(
                            'Tap to choose a time',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add your task creation logic here
                      String taskName = _taskNameController.text;
                      String taskTime = _selectedTime.format(context);
                      // Perform actions with task name and time, e.g., saving to database
                      print('Task Name: $taskName, Task Time: $taskTime');
                      // Change color of the day to light pink
                      setState(() {
                        _taskColors[_selectedDay] = Colors.pink[100]!;
                      });
                      // Clear text field
                      _taskNameController.clear();
                    },
                    child: Text('Add Task'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
