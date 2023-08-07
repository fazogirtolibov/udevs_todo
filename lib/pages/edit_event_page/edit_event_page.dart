import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_todo/core/widgets/custom_button.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../constants/icons.dart';
import '../../core/bloc/calendar_bloc/calendar_bloc.dart';
import '../../core/bloc/show_pop_up_bloc/show_pop_up_bloc.dart';
import '../../core/data/models/event_model.dart';
import '../../core/widgets/custom_animation.dart';
import '../../core/widgets/custom_bottom_sheet.dart';
import '../../core/widgets/custom_show_dialog.dart';
import '../../core/widgets/custom_text_field.dart';

class EditAnEventPage extends StatefulWidget {
  const EditAnEventPage({super.key, required this.model});
  final EventModel model;
  @override
  State<EditAnEventPage> createState() => _EditAnEventPageState();
}

class _EditAnEventPageState extends State<EditAnEventPage> {
  late final TextEditingController eventNameController;
  late final TextEditingController eventDescriptionController;
  late final TextEditingController eventLocationController;
  late int colorIndex;
  late String eventTime;

  @override
  void initState() {
    final model = widget.model;
    eventNameController = TextEditingController(text: model.name);
    eventDescriptionController = TextEditingController(text: model.description);
    eventLocationController = TextEditingController(text: model.location);
    eventTime = model.time;
    colorIndex = model.colorIndex;

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
    if (eventNameController.text != widget.model.name ||
        eventDescriptionController.text != widget.model.description ||
        eventLocationController.text != widget.model.location ||
        eventTime != widget.model.time ||
        colorIndex != widget.model.colorIndex) {
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
                          DropdownButtonHideUnderline(
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
                    'Save',
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    if (eventNameController.text.isNotEmpty) {
                      final EventModel newModel = EventModel(
                        id: widget.model.id,
                        day: widget.model.day,
                        name: eventNameController.text,
                        description: eventDescriptionController.text,
                        time: eventTime,
                        location: eventLocationController.text,
                        colorIndex: colorIndex,
                      );
                      context.read<CalendarBloc>().add(
                            CalendarEvent.updateAnEvent(
                              newModel: newModel,
                              onFailure: (error) {
                                context.read<ShowPopUpBloc>().add(
                                    ShowPopUpEvent.showFailure(text: error));
                              },
                              onSuccess: () {
                                Navigator.pop(context);
                                context.read<ShowPopUpBloc>().add(
                                      ShowPopUpEvent.showSuccess(
                                          text: 'Task successfully updated'),
                                    );
                              },
                            ),
                          );
                    } else {
                      context.read<ShowPopUpBloc>().add(
                            ShowPopUpEvent.showWarning(text: 'Enter your name'),
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
