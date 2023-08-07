import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_todo/core/data/calendar_data/date_time.dart';

import '../../../../../constants/app_functions.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/icons.dart';
import '../../../core/widgets/custom_button.dart';

class WCalendarHeader extends StatelessWidget {
  const WCalendarHeader({
    super.key,
    required this.selectedMonth,
    required this.onChange,
  });

  final DateTime selectedMonth;

  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppFunctions.getMonth(selectedMonth.month),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              CustomButton(
                height: 24,
                width: 24,
                onTap: () {
                  onChange(selectedMonth.addMonth(-1));
                },
                color: grey,
                borderRadius: 30,
                child: SvgPicture.asset(AppIcons.arrowLeft),
              ),
              const SizedBox(width: 10),
              CustomButton(
                height: 24,
                width: 24,
                onTap: () {
                  onChange(selectedMonth.addMonth(1));
                },
                color: grey,
                borderRadius: 30,
                child: SvgPicture.asset(AppIcons.arrowRight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
