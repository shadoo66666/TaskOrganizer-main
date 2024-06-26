import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';
import 'package:task_app/constants/app_style.dart';

class SubtaskSection extends StatefulWidget {
  final List<TextEditingController> subtaskControllers;

  const SubtaskSection({
    Key? key,
    required this.subtaskControllers,
  }) : super(key: key);

  @override
  _SubtaskSectionState createState() => _SubtaskSectionState();
}

class _SubtaskSectionState extends State<SubtaskSection> {
  List<bool?> isCheckedList = [];
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _initKeyboardListener();
  }

  void _initKeyboardListener() {
    // Add listener to keyboard visibility
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom > 0;
      setState(() {
        isKeyboardVisible = keyboardVisibility;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Handle scroll notification
        if (notification is UserScrollNotification) {
          _hideKeyboard();
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.subtaskControllers.isNotEmpty)
              const Row(
                children: [
                  FaIcon(FontAwesomeIcons.listCheck),
                  Gap(9),
                  Text(
                    'Subtasks',
                    style: AppStyle.headingOne,
                  ),
                ],
              ),
            ..._buildSubtaskWidgets(),
            InkWell(
              onTap: _addSubtask,
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.plus),
                  Gap(11),
                  Text(
                    'Add Subtask',
                    style: AppStyle.headingOne,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubtaskWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.subtaskControllers.length; i++) {
      if (isCheckedList.length <= i) {
        isCheckedList.add(false);
      }
      widgets.add(
        Row(
          children: [
            Checkbox(
              value: isCheckedList[i],
              onChanged: (value) {
                setState(() {
                  isCheckedList[i] = value;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.subtaskControllers[i],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.subtaskControllers.removeAt(i);
                  isCheckedList.removeAt(i);
                });
              },
            ),
          ],
        ),
      );
    }
    return widgets;
  }

  void _addSubtask() {
    setState(() {
      widget.subtaskControllers.add(TextEditingController());
      isCheckedList.add(false);
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
