import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  void _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeEnabled = value;
      prefs.setBool('darkMode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: _darkModeEnabled ? Colors.white : Colors.black, // Change text color based on dark mode state
          ),
        ),
        backgroundColor: _darkModeEnabled ? Colors.grey.shade900 : Colors.white,
      ),
      body: Container(
        color: _darkModeEnabled ? Colors.grey.shade900 : Colors.white,
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: _darkModeEnabled ? Colors.white : Colors.black, // Change text color based on dark mode state
                ),
              ),
              value: _darkModeEnabled,
              onChanged: _toggleDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}
