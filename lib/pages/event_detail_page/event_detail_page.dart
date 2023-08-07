import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_constants.dart';
import '../../../../constants/icons.dart';
import '../../../../core/bloc/calendar_bloc/calendar_bloc.dart';
import '../../../../core/bloc/show_pop_up_bloc/show_pop_up_bloc.dart';
import '../../../../core/data/models/event_model.dart';
import '../../core/widgets/custom_show_dialog.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_animation.dart';

import '../../../../constants/colors.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.model});
  final EventModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              color: AppConstants.todoLightColors[model.colorIndex],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomButton(
                        borderRadius: 30,
                        padding: const EdgeInsets.all(8),
                        onTap: () => Navigator.pop(context),
                        color: white,
                        child: SvgPicture.asset(
                          AppIcons.arrowLeft,
                          height: 24,
                        ),
                      ),
                      const Spacer(),
                      CustomAnimation(
                        onTap: () {},
                        child: Row(
                          children: [
                            SvgPicture.asset(AppIcons.edit),
                            const SizedBox(width: 4),
                            const Text(
                              'Edit',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    model.name,
                    style: const TextStyle(
                      color: white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (model.description.isNotEmpty)
                    Text(
                      model.description,
                      style: const TextStyle(
                          color: white,
                          fontSize: 8,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (model.time.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          SvgPicture.asset(AppIcons.clock, color: white),
                          const SizedBox(width: 4),
                          Text(
                            model.time,
                            style: const TextStyle(
                                color: white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  if (model.location.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          // ignore: deprecated_member_use
                          SvgPicture.asset(AppIcons.location, color: white),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              model.location,
                              style: const TextStyle(
                                color: white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(28),
              children: [
                const Text(
                  'Reminder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  '15 minutes before',
                  style: TextStyle(
                      color: darkGreyText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 22),
                if (model.description.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        model.description,
                        style: const TextStyle(
                            color: greyText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
              ],
            ),
          ),
          CustomButton(
            margin: const EdgeInsets.all(28),
            borderRadius: 10,
            height: 50,
            color: red.withOpacity(0.2),
            onTap: () {
              customShowDialog(
                  context: context,
                  content: const Text('Do you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<CalendarBloc>().add(
                              CalendarEvent.deleteAnEvent(
                                model: model,
                                onSuccess: () => Navigator.pop(context),
                                onFailure: (message) => context
                                    .read<ShowPopUpBloc>()
                                    .add(ShowPopUpEvent.showFailure(
                                        text: message)),
                              ),
                            );
                      },
                    )
                  ]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcons.bin),
                const Text(
                  'Delete Task',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
