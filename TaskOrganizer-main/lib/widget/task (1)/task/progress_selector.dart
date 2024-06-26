import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class TaskProgressSelector {
  late String defaultProgress;
  final ValueChanged<String> onProgressChanged;
  late Widget progressIndicator = SizedBox(); // Initialize with a default SizedBox

  TaskProgressSelector({
    required this.defaultProgress,
    required this.onProgressChanged,
  });
 // Define progressIndicator variable

  void updateProgressIndicator(BuildContext context) {
    progressIndicator = buildProgressIndicator(context);
  }

  Future<void> showProgressDialog(BuildContext context) async {
  String? newProgress = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildProgressOption('TO DO', Colors.grey, context),
            _buildProgressOption('IN PROGRESS', Colors.blue, context),
            _buildProgressOption('COMPLETE', Colors.green, context),
          ],
        ),
      );
    },
  );
  if (newProgress != null) {
    defaultProgress = newProgress; // Update defaultProgress with the chosen progress
    onProgressChanged(newProgress);
  }
}

  Widget _buildProgressOption(String progress, Color color, BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
            margin: EdgeInsets.only(right: 8),
          ),
          Text(progress),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop(progress);
      },
    );
  }

  Widget buildProgressIndicator(BuildContext context) {
    return InkWell(
      onTap: () {
        showProgressDialog(context);
      },
      child: Row(
        children: [
          getIcon(defaultProgress),
          Gap(5),
          Container(
            decoration: BoxDecoration(
              color: getColor(defaultProgress),
              borderRadius: BorderRadius.circular(6)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
              child: Text(defaultProgress, style: TextStyle(color: Colors.white),),
            )),
        ],
      ),
    );
  }

  Color getColor(String progress) {
    switch (progress) {
      case 'TO DO':
        return Colors.grey;
      case 'IN PROGRESS':
        return Colors.blue;
      case 'COMPLETE':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  FaIcon getIcon(String progress) {
    switch (progress) {
      case 'TO DO':
        return FaIcon(FontAwesomeIcons.circle);
      case 'IN PROGRESS':
        return FaIcon(FontAwesomeIcons.circleHalfStroke);
      case 'COMPLETE':
        return FaIcon(FontAwesomeIcons.solidCircleCheck);
      default:
        return FaIcon(FontAwesomeIcons.circle);
    }
  }
}
