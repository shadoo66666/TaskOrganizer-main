import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:task_app/constants/app_style.dart';


class DateTimeWidget extends ConsumerWidget {
  const DateTimeWidget(
      {super.key,
      required this.titleText,
      required this.valueText,
      required this.iconSection,
      required this.onTap});
  final String titleText;
  final String valueText;
  final IconData iconSection;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        titleText,
        style: AppStyle.headingOne,
      ), // Text
      const Gap(6),
      Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ), // BoxDecoration
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onTap(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ), // EdgeInsets. symmetric
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ), // BoxDecoration
              child: Row(children: [
                Icon(iconSection, color: Colors.black,),
                const Gap(12),
                Text(valueText, style: TextStyle(color: Colors.black),),
              ]),
            ),
          ),
        ),
      ),
    ]));
  }
}