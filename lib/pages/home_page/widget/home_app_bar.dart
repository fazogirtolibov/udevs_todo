import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../constants/app_functions.dart';
import '../../../../../constants/icons.dart';
import '../../../../../core/bloc/calendar_bloc/calendar_bloc.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_animation.dart';

class WHomeAppBar extends StatelessWidget {
  const WHomeAppBar({
    super.key,
    required this.selectedDate,
  });
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 28),
          CustomAnimation(
            onTap: () {
              DateTime selectedDate = DateTime.now();
              customShowBottomSheet(
                  context: context,
                  buttonTitle: 'Go',
                  onTapButton: () {
                    Navigator.pop(context);
                    context
                        .read<CalendarBloc>()
                        .add(CalendarEvent.changeSelectedMonth(selectedDate));
                    context
                        .read<CalendarBloc>()
                        .add(CalendarEvent.changeSelectedDate(selectedDate));
                  },
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      child: CupertinoDatePicker(
                        maximumDate: DateTime(2950),
                        minimumDate: DateTime(1950),
                        initialDateTime:
                            context.read<CalendarBloc>().state.selectedDate,
                        onDateTimeChanged: (newdate) => selectedDate = newdate,
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    )
                  ]);
            },
            child: Column(
              children: [
                Text(
                  AppFunctions.getDayOfWeek(selectedDate.weekday),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      '${selectedDate.day} ${AppFunctions.getMonth(selectedDate.month)} ${selectedDate.year}',
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(AppIcons.bottomArrow)
                  ],
                ),
              ],
            ),
          ),
          CustomAnimation(
            onTap: () {},
            child: SvgPicture.asset(AppIcons.ring),
          ),
        ],
      ),
    );
  }
}
