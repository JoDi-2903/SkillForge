import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/main.dart';

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

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  appointments.add(Appointment(
    startTime: DateTime.now().subtract(const Duration(hours: 1)),
    endTime: DateTime.now().add(const Duration(hours: 1)),
    isAllDay: true,
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  ));

  return DataSource(appointments);
}

class MonthCalendarCard extends Card {
  MonthCalendarCard({
    super.key,
    required this.context,
    this.initDate,
    this.control,
    this.factorScaling = 1,
    this.cellOffset = 0,
  }) : super(
            margin: const EdgeInsets.all(7),
            child: SfCalendarTheme(
                data: SfCalendarThemeData(
                    todayBackgroundColor: AppColorScheme.indigo),
                child: MonthCalendar(
                  context: context,
                  initDate: initDate,
                  control: control,
                  factorScaling: factorScaling,
                  cellOffset: cellOffset,
                )));
  final BuildContext context;
  final DateTime? initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
}

class MonthCalendar extends SfCalendar {
  MonthCalendar({
    super.key,
    required this.context,
    DateTime? initDate,
    this.control,
    required this.factorScaling,
    required this.cellOffset,
  })  : initDate = initDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45),
        super(
            view: CalendarView.month,
            firstDayOfWeek: 1,
            dataSource: _getCalendarDataSource(),
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
                  color: AppColorScheme.ownBlack,
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
                  color: AppColorScheme.ownBlack,
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
            selectionDecoration: BoxDecoration(
              border: Border.all(color: AppColorScheme.indigo, width: 2),
            ),
            viewHeaderHeight:
                factorScaling * 3 * AutoScalingFactor.cellTextScaler(context),
            viewHeaderStyle: ViewHeaderStyle(
              backgroundColor: AppColorScheme.ownWhite,
              dayTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize: factorScaling *
                    2 *
                    AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
            ));

  final BuildContext context;
  final DateTime initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
}

class WeekCalendarCard extends Card {
  WeekCalendarCard({
    super.key,
    required this.context,
    this.initDate,
    this.control,
    this.factorScaling = 1,
    this.cellOffset = 0,
  }) : super(
            margin: const EdgeInsets.all(7),
            child: SfCalendarTheme(
                data: SfCalendarThemeData(
                    todayBackgroundColor: AppColorScheme.indigo),
                child: WeekCalendar(
                  context: context,
                  initDate: initDate,
                  control: control,
                  factorScaling: factorScaling,
                  cellOffset: cellOffset,
                )));
  final BuildContext context;
  final DateTime? initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
}

class WeekCalendar extends SfCalendar {
  WeekCalendar({
    super.key,
    required this.context,
    DateTime? initDate,
    this.control,
    required this.factorScaling,
    required this.cellOffset,
  })  : initDate = initDate ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 08, 45),
        super(
            view: CalendarView.week,
            firstDayOfWeek: 1,
            dataSource: _getCalendarDataSource(),
            backgroundColor: AppColorScheme.ownWhite,
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
                  fontSize: factorScaling *
                      2.5 *
                      AutoScalingFactor.cellTextScaler(context),
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
            selectionDecoration: BoxDecoration(
              border: Border.all(color: AppColorScheme.indigo, width: 2),
            ),
            viewHeaderHeight:
                factorScaling * 8 * AutoScalingFactor.cellTextScaler(context),
            viewHeaderStyle: ViewHeaderStyle(
              backgroundColor: AppColorScheme.ownWhite,
              dayTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize: factorScaling *
                    2 *
                    AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
              dateTextStyle: TextStyle(
                color: AppColorScheme.ownBlack,
                fontSize: factorScaling *
                    2 *
                    AutoScalingFactor.cellTextScaler(context),
                height: -1.01 + cellOffset,
              ),
            ));

  final BuildContext context;
  final DateTime initDate;
  final CalendarController? control;
  final double factorScaling;
  final double cellOffset;
}
