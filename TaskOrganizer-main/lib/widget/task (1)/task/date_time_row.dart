import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:task_app/provider/date_time_provider.dart';
import 'package:task_app/widget/task%20(1)/task/date_time_widget.dart';


class DateTimeRow extends ConsumerWidget {
  const DateTimeRow({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateProv = ref.watch(dateProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateTimeWidget(
          titleText: 'Date',
          valueText: dateProv.toString(),
          iconSection: CupertinoIcons.calendar,
          onTap: () async {
            final getValue = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2025),
            );
            if (getValue != null) {
              final format = DateFormat.yMd();
              ref.read(dateProvider.notifier).update((state) => format.format(getValue));
            }
          },
        ),
        const Gap(22),
        DateTimeWidget(
          titleText: 'Time',
          valueText: ref.watch(timeProvider),
          iconSection: CupertinoIcons.clock,
          onTap: () async {
            final getTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (getTime != null) {
              ref.read(timeProvider.notifier).update((state) => getTime.format(context));
            }
          },
        ),
      ],
    );
  }
}
