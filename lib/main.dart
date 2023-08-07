import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:udevs_todo/pages/home_page/home_page.dart';

import 'constants/colors.dart';
import 'constants/app_theme.dart';
import 'core/bloc/calendar_bloc/calendar_bloc.dart';
import 'core/bloc/show_pop_up_bloc/show_pop_up_bloc.dart';
import 'core/data/database/database_service.dart';
import 'core/data/get_it.dart';
import 'core/data/models/popup_types.dart';
import 'core/widgets/custom_popups.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  await setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CalendarBloc()..add(const CalendarEvent.init()),
        ),
        BlocProvider(
          create: (context) => ShowPopUpBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<ShowPopUpBloc, ShowPopUpState>(
          listener: (context, state) {
            if (state.showPopUp && state.popUpType == PopUpType.error) {
              showSimpleNotification(
                CustomPopUp(color: red.withOpacity(0.5), text: state.errorText),
                elevation: 0,
                background: Colors.transparent,
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
              );
            } else if (state.showPopUp &&
                state.popUpType == PopUpType.warning) {
              showSimpleNotification(
                CustomPopUp(
                  color: orange,
                  text: state.warningText,
                ),
                elevation: 0,
                background: Colors.transparent,
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
              );
            } else if (state.showPopUp &&
                state.popUpType == PopUpType.success) {
              showSimpleNotification(
                CustomPopUp(
                  color: green,
                  text: state.successText,
                ),
                elevation: 0,
                background: Colors.transparent,
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
              );
            }
          },
          child: OverlaySupport.global(
            child: MaterialApp(
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: ThemeMode.light,
              home: const HomePage(),
            ),
          ),
        );
      }),
    );
  }
}
