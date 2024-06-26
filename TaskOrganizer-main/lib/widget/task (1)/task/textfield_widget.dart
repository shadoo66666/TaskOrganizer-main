import 'package:flutter/material.dart';
class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.txtController,
  }) : super(key: key);

  final String hintText;
  final TextEditingController txtController;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.txtController,
        style: TextStyle(color: Colors.black), // Set the text color to black
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
        minLines: 1,
        maxLines: 5,
      ),
    );
  }
}
