import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';
import '../../constants/app_constants.dart';
import '../../../../constants/icons.dart';
import '../../constants/app_theme.dart';
import '../../../../core/bloc/calendar_bloc/calendar_bloc.dart';
import '../../../../core/bloc/show_pop_up_bloc/show_pop_up_bloc.dart';
import '../../../../core/data/models/event_model.dart';
import '../../core/widgets/custom_bottom_sheet.dart';
import '../../core/widgets/custom_show_dialog.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_animation.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key, required this.selectedDate});
  final DateTime selectedDate;
  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late final TextEditingController eventNameController;
  late final TextEditingController eventDescriptionController;
  late final TextEditingController eventLocationController;

  int colorIndex = 0;
  String eventTime = '';
  Duration duration = const Duration(seconds: 0);

  @override
  void initState() {
    eventNameController = TextEditingController();
    eventDescriptionController = TextEditingController();
    eventLocationController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventLocationController.dispose();

    super.dispose();
  }

  Future<bool> willExit() async {
    if (eventNameController.text.isNotEmpty ||
        eventDescriptionController.text.isNotEmpty ||
        eventLocationController.text.isNotEmpty) {
      customShowDialog(
        context: context,
        content: const Text('Do you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          )
        ],
      );
      return false;
    }

    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme()
          .copyWith(brightness: Theme.of(context).brightness),
      child: WillPopScope(
        onWillPop: () => willExit(),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    primary: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13, right: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAnimation(
                            onTap: () => willExit(),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SvgPicture.asset(
                                AppIcons.back,
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ),
                          CustomTextField(
                            title: 'Event name',
                            maxLength: 50,
                            controller: eventNameController,
                          ),
                          CustomTextField(
                            title: 'Event description',
                            textInputAction: TextInputAction.newline,
                            controller: eventDescriptionController,
                            maxLines: 6,
                          ),
                          CustomTextField(
                            title: 'Event location',
                            maxLength: 40,
                            controller: eventLocationController,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: colorIndex,
                                items: AppConstants.todoLightColors
                                    .map((Color color) {
                                  return DropdownMenuItem<int>(
                                    value: AppConstants.todoLightColors
                                        .indexOf(color),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      color: color,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (selectedColorIndex) {
                                  if (selectedColorIndex != null) {
                                    colorIndex = selectedColorIndex;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                          CustomTextField(
                            title: 'Event time',
                            isReadOnly: true,
                            onTap: () {
                              DateTime selectedTime = DateTime.now();
                              customShowBottomSheet(
                                  context: context,
                                  onTapButton: () {
                                    final hour = selectedTime.hour < 10
                                        ? '0${selectedTime.hour}'
                                        : selectedTime.hour.toString();
                                    final min = selectedTime.minute < 10
                                        ? '0${selectedTime.minute}'
                                        : selectedTime.minute.toString();
                                    eventTime = '$hour:$min';
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height /
                                          3,
                                      child: CupertinoDatePicker(
                                        initialDateTime: DateTime.now(),
                                        onDateTimeChanged: (newdate) =>
                                            selectedTime = newdate,
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.time,
                                      ),
                                    ),
                                  ]);
                            },
                            controller: TextEditingController(text: eventTime),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  margin: const EdgeInsets.all(16),
                  height: 45,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    if (eventNameController.text.isNotEmpty) {
                      final EventModel model = EventModel(
                        day: widget.selectedDate.toIso8601String(),
                        name: eventNameController.text,
                        description: eventDescriptionController.text,
                        time: eventTime,
                        location: eventLocationController.text,
                        colorIndex: colorIndex,
                      );
                      context.read<CalendarBloc>().add(
                            CalendarEvent.addNewEvent(
                              model: model,
                              onFailure: (error) {
                                context.read<ShowPopUpBloc>().add(
                                    ShowPopUpEvent.showFailure(text: error));
                              },
                              onSuccess: () {
                                Navigator.pop(context);
                                context.read<ShowPopUpBloc>().add(
                                      ShowPopUpEvent.showSuccess(
                                          text: 'New Task successfully added'),
                                    );
                              },
                            ),
                          );
                    } else {
                      context.read<ShowPopUpBloc>().add(
                            ShowPopUpEvent.showWarning(text: 'Add a task name'),
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
