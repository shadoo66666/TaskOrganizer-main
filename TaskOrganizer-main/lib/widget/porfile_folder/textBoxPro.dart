import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textBOXS extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const textBOXS({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 211, 232),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Section name
                  Text(
                    text,
                    style: TextStyle(color: Colors.grey),
                  ),
                  // Edit button
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
