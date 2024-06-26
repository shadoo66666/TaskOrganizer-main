
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/constants/app_style.dart';
import 'package:task_app/provider/radio_provider.dart';
import 'package:task_app/widget/task%20(1)/task/radio_widget.dart';


class CategorySelection extends StatelessWidget {
  const CategorySelection({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: AppStyle.headingOne,),
        Row(
          children: [
            Expanded(
              child: RadioWidget(
                categColor: Colors.green,
                titleRadio: 'LRN',
                valueInput: 1,
                onChangeValue: () =>
                    ref.read(radioProvider.notifier).update((state) => 1),
              ),
            ),
            Expanded(
              child: RadioWidget(
                categColor: Colors.blue.shade700,
                titleRadio: 'WRK',
                valueInput: 2,
                onChangeValue: () =>
                    ref.read(radioProvider.notifier).update((state) => 2),
              ),
            ),
            Expanded(
              child: RadioWidget(
                categColor: Colors.amberAccent.shade700,
                titleRadio: 'GEN',
                valueInput: 3,
                onChangeValue: () =>
                    ref.read(radioProvider.notifier).update((state) => 3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
