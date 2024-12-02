import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/main.dart';
import 'package:skill_forge/screens/appointment_detail_screen.dart';

class MonthNavigationBar extends BottomNavigationBar {
  MonthNavigationBar({
    super.key,
    required this.onTapped(int index),
    required this.selectedIndex,
  }) : super(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.yearLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.monthLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.reset_tv,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.resetLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_forward,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.monthLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_forward,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.yearLabel,
            ),
          ],
          backgroundColor: AppColorScheme.antiFlash,
          selectedItemColor: AppColorScheme.indigo,
          unselectedItemColor: AppColorScheme.indigo,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          currentIndex: selectedIndex,
          onTap: onTapped,
        );
  final Function(int index) onTapped;
  final int selectedIndex;
}

class WeekNavigationBar extends BottomNavigationBar {
  WeekNavigationBar({
    super.key,
    required this.onTapped(int index),
    required this.selectedIndex,
  }) : super(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.weekLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.reset_tv,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.resetLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_forward,
                color: AppColorScheme.indigo,
              ),
              label: AppStrings.weekLabel,
            ),
          ],
          backgroundColor: AppColorScheme.antiFlash,
          selectedItemColor: AppColorScheme.indigo,
          unselectedItemColor: AppColorScheme.indigo,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          currentIndex: selectedIndex,
          onTap: onTapped,
        );
  final Function(int index) onTapped;
  final int selectedIndex;
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

Future<DataSource> _getCalendarDataSource(Map<String, dynamic> filters) async {
  // Prepare the language parameter
  String language = MyApp.language.languageCode.toUpperCase();
  if (language == 'ZH') {
    language = 'EN';
  }

  // Optional parameters
  Map<String, String> params = {
    'language': language,
  };

  // Add filters to params
  if (filters['user_id'] != null) {
    params['user_id'] = filters['user_id'];
  }
  if (filters['event_type'] != null && filters['event_type'].isNotEmpty) {
    params['event_type'] = filters['event_type'].join(',');
  }
  if (filters['subject_area'] != null && filters['subject_area'].isNotEmpty) {
    params['subject_area'] = filters['subject_area'].join(',');
  }

  // Build the URI with query parameters
  Uri uri = Uri.http('127.0.0.1:5000', '/api/calendar-events', params);

  // Fetch data from the API
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    List<Appointment> appointments = [];

    for (var event in data) {
      // Determine the color based on 'subject_area'
      Color color;
      switch (event['subject_area']) {
        case 'Computer Science':
          color = AppColorScheme.computerScience;
          break;
        case 'Electrical Engineering':
          color = AppColorScheme.electricalEngineering;
          break;
        case 'Mechanical Engineering':
          color = AppColorScheme.mechanicalEngineering;
          break;
        case 'Mechatronics':
          color = AppColorScheme.mechatronics;
          break;
        default:
          color = AppColorScheme.otherSubject;
      }

      // Parse dates
      for (var dateInfo in event['dates']) {
        DateTime startTime =
            DateTime.parse('${dateInfo['date']} ${dateInfo['start_time']}');
        DateTime endTime =
            DateTime.parse('${dateInfo['date']} ${dateInfo['end_time']}');
        String location =
            '${dateInfo['location']}, ${dateInfo['federal_state']}';

        // Create Appointment
        appointments.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: event['title'],
          color: color,
          notes: dateInfo['day_id'].toString(),
          location: location,
        ));
      }
    }

    return DataSource(appointments);
  } else {
    throw Exception('Failed to load appointments');
  }
}

class MonthCalendarCard extends Card {
  MonthCalendarCard({
    super.key,
    required this.context,
    this.initDate,
    this.control,
    this.factorScaling = 1,
    this.cellOffset = 0,
    required this.filters,
  }) : super(
            margin: const EdgeInsets.all(7),
            child: SfCalendarTheme(
                data: SfCalendarThemeData(
                  todayBackgroundColor: AppColorScheme.indigo,
                  selectionBorderColor: Colors.transparent,
                ),
                child: MonthCalendar(
                  context: context,
                  initDate: initDate,
                  control: control,
                  factorScaling: factorScaling,
                  cellOffset: cellOffset,
                  filters: filters,
                )));
  final BuildContext context;
  final DateTime? initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
  final Map<String, dynamic> filters;
}

class MonthCalendar extends StatelessWidget {
  MonthCalendar({
    super.key,
    required this.context,
    DateTime? initDate,
    this.control,
    required this.factorScaling,
    required this.cellOffset,
    required this.filters,
  }) : initDate = initDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45);

  final BuildContext context;
  final DateTime initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
  final Map<String, dynamic> filters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSource>(
      future: _getCalendarDataSource(filters), // Fetch the data source
      builder: (BuildContext context, AsyncSnapshot<DataSource> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if something went wrong
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Build the SfCalendar with the fetched data
          return SfCalendar(
            view: CalendarView.month,
            firstDayOfWeek: 1,
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            dataSource: snapshot.data,
            backgroundColor: AppColorScheme.ownWhite,
            initialDisplayDate: initDate,
            controller: control,
            headerHeight:
                factorScaling * 4.5 * AutoScalingFactor.cellTextScaler(context),
            viewNavigationMode: ViewNavigationMode.none,
            headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(
                  color: AppColorScheme.ownBlack,
                  fontSize: factorScaling *
                      2.5 *
                      AutoScalingFactor.cellTextScaler(context),
                ),
                textAlign: TextAlign.center,
                backgroundColor: AppColorScheme.antiFlash),
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              appointmentDisplayCount: 2,
              monthCellStyle: MonthCellStyle(
                leadingDatesTextStyle: TextStyle(
                  fontSize:
                      factorScaling * AutoScalingFactor.cellTextScaler(context),
                  height: -1.01 + cellOffset,
                ),
                textStyle: TextStyle(
                  color: AppColorScheme.ownBlack,
                  fontSize:
                      factorScaling * AutoScalingFactor.cellTextScaler(context),
                  height: -1.01 + cellOffset,
                ),
                trailingDatesTextStyle: TextStyle(
                  fontSize:
                      factorScaling * AutoScalingFactor.cellTextScaler(context),
                  height: -1.01 + cellOffset,
                ),
                leadingDatesBackgroundColor: AppColorScheme.antiFlash,
                trailingDatesBackgroundColor: AppColorScheme.antiFlash,
              ),
            ),
            appointmentTextStyle: TextStyle(
              color: AppColorScheme.ownWhite,
              fontSize:
                  factorScaling * AutoScalingFactor.cellTextScaler(context),
            ),
            todayHighlightColor: AppColorScheme.indigo,
            todayTextStyle: TextStyle(
              color: AppColorScheme.ownBlack,
              fontSize:
                  factorScaling * AutoScalingFactor.cellTextScaler(context),
              height: -1.01 + cellOffset,
            ),
            viewHeaderHeight:
                factorScaling * 3 * AutoScalingFactor.cellTextScaler(context),
            viewHeaderStyle: ViewHeaderStyle(
              backgroundColor: AppColorScheme.ownWhite,
              dayTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize:
                    factorScaling * AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
            ),
            // Handle appointment taps
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null &&
                  details.appointments!.isNotEmpty) {
                Appointment appointment = details.appointments!.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailScreen(
                      dayId: appointment.notes!,
                    ),
                  ),
                );
              }
            },
          );
        } else {
          // In case there's no data
          return Center(child: Text('No appointments available'));
        }
      },
    );
  }
}

class WeekCalendarCard extends Card {
  WeekCalendarCard({
    super.key,
    required this.context,
    this.initDate,
    this.control,
    this.factorScaling = 1,
    this.cellOffset = 0,
    required this.filters,
  }) : super(
            margin: const EdgeInsets.all(7),
            child: SfCalendarTheme(
                data: SfCalendarThemeData(
                  todayBackgroundColor: AppColorScheme.indigo,
                  selectionBorderColor: Colors.transparent,
                ),
                child: WeekCalendar(
                  context: context,
                  initDate: initDate,
                  control: control,
                  factorScaling: factorScaling,
                  cellOffset: cellOffset,
                  filters: filters,
                )));
  final BuildContext context;
  final DateTime? initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
  final Map<String, dynamic> filters;
}

class WeekCalendar extends StatelessWidget {
  WeekCalendar({
    super.key,
    required this.context,
    DateTime? initDate,
    this.control,
    required this.factorScaling,
    required this.cellOffset,
    required this.filters,
  }) : initDate = initDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45);

  final BuildContext context;
  final DateTime initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
  final Map<String, dynamic> filters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSource>(
      future: _getCalendarDataSource(filters), // Fetch the data source
      builder: (BuildContext context, AsyncSnapshot<DataSource> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if something went wrong
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Build the SfCalendar with the fetched data
          return SfCalendar(
            view: CalendarView.week,
            firstDayOfWeek: 1,
            dataSource: snapshot.data,
            backgroundColor: AppColorScheme.ownWhite,
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            timeSlotViewSettings: TimeSlotViewSettings(
                timeTextStyle: TextStyle(
              color: AppColorScheme.ownBlack,
            )),
            initialDisplayDate: initDate,
            controller: control,
            headerHeight:
                factorScaling * 6 * AutoScalingFactor.cellTextScaler(context),
            viewNavigationMode: ViewNavigationMode.none,
            headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(
                  color: AppColorScheme.ownBlack,
                  fontSize:
                      factorScaling * AutoScalingFactor.cellTextScaler(context),
                ),
                textAlign: TextAlign.center,
                backgroundColor: AppColorScheme.antiFlash),
            appointmentTextStyle: TextStyle(
              color: AppColorScheme.ownWhite,
              fontSize:
                  factorScaling * AutoScalingFactor.cellTextScaler(context),
            ),
            todayHighlightColor: AppColorScheme.indigo,
            todayTextStyle: TextStyle(
              color: AppColorScheme.ownBlack,
              fontSize:
                  factorScaling * AutoScalingFactor.cellTextScaler(context),
              height: -1.01 + cellOffset,
            ),
            viewHeaderHeight:
                factorScaling * 8 * AutoScalingFactor.cellTextScaler(context),
            viewHeaderStyle: ViewHeaderStyle(
              backgroundColor: AppColorScheme.ownWhite,
              dayTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize:
                    factorScaling * AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
              dateTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize:
                    factorScaling * AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
            ),
            // Handle appointment taps
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null &&
                  details.appointments!.isNotEmpty) {
                Appointment appointment = details.appointments!.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailScreen(
                      dayId: appointment.notes!,
                    ),
                  ),
                );
              }
            },
          );
        } else {
          // In case there's no data
          return Center(child: Text('No appointments available'));
        }
      },
    );
  }
}
