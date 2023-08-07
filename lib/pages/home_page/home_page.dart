import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_todo/core/widgets/custom_button.dart';
import 'package:udevs_todo/pages/home_page/widget/calendar_body.dart';
import 'package:udevs_todo/pages/home_page/widget/calendar_header.dart';
import 'package:udevs_todo/pages/home_page/widget/home_app_bar.dart';

import '../../constants/colors.dart';
import '../../constants/page_route.dart';
import '../../core/bloc/calendar_bloc/calendar_bloc.dart';
import '../../core/bloc/show_pop_up_bloc/show_pop_up_bloc.dart';
import '../../core/data/models/form_status.dart';
import '../add_event_page/add_event_page.dart';
import '../event_detail_page/widget/event_preview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (state.selectedMonth == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final selectedMonth = state.selectedMonth!;
            final selectedDate = state.selectedDate;
            return Column(
              children: [
                WHomeAppBar(selectedDate: selectedDate ?? DateTime.now()),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    children: [
                      SizedBox(
                        height: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WCalendarHeader(
                                selectedMonth: selectedMonth,
                                onChange: (value) => context
                                    .read<CalendarBloc>()
                                    .add(CalendarEvent.changeSelectedMonth(
                                        value))),
                            WCalendarBody(
                              selectedDate: selectedDate,
                              selectedMonth: selectedMonth,
                              selectDate: (value) => context
                                  .read<CalendarBloc>()
                                  .add(CalendarEvent.changeSelectedDate(value)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Schedule',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          CustomButton(
                            borderRadius: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            height: 30,
                            color: blue,
                            onTap: () {
                              if (selectedDate != null) {
                                Navigator.push(
                                  context,
                                  cupertino(
                                      page: AddEventPage(
                                          selectedDate: selectedDate)),
                                );
                              } else {
                                context.read<ShowPopUpBloc>().add(
                                    ShowPopUpEvent.showWarning(
                                        text:
                                            'Please choose a day to create an event'));
                              }
                            },
                            child: const Text(
                              '+ Add Event',
                              style: TextStyle(
                                color: white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Builder(builder: (context) {
                        return () {
                          if (state.status == FormStatus.submissionSuccess) {
                            final models = state.models;
                            if (models.isEmpty) {
                              return const Center(
                                  child: Text('No Tasks on this day'));
                            } else {
                              return ListView.separated(
                                itemCount: models.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return WEventPreview(model: models[index]);
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14),
                              );
                            }
                          } else if (state.status ==
                              FormStatus.submissionInProgress) {
                            return const Center(
                                child: CircularProgressIndicator(color: blue));
                          } else if (state.status == FormStatus.pure) {
                            return const Center(
                              child: Text('Select a date and add your task'),
                            );
                          }
                          return const SizedBox();
                        }();
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
