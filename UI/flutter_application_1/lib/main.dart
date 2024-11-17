import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff034875)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool switchValue = false;
  int displayedYear = DateTime.now().year;
  final controllers = <CalendarController>[
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
    CalendarController(),
  ];


  @override
  void initState() {
    for (var i = 0; i < 12; i++) {
      controllers[i] = CalendarController();
    }
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0){
        for (var i = 0; i < 12; i++) {  
          for (var j = 0; j < 12; j++){
            controllers[i].backward!();
          }
        }
      }
      else if (index == 4){
        for (var i = 0; i < 12; i++) {  
          for (var j = 0; j < 12; j++){
            controllers[i].forward!();
          }
        }
      }
      else if (index == 3){
        for (var i = 0; i < 12; i++) {  
          controllers[i].forward!();
        }
      }
      else if (index == 1){
        for (var i = 0; i < 12; i++) {  
          controllers[i].backward!();
        }
      }
      else{
        for (var i = 0; i < 12; i++) {  
          controllers[i].displayDate = DateTime(DateTime.now().year, i+1);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final yearCalendar = <MonthCalendarCard>[
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 1), control:controllers[0]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 2), control:controllers[1]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 3), control:controllers[2]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 4), control:controllers[3]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 5), control:controllers[4]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 6), control:controllers[5]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 7), control:controllers[6]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 8), control:controllers[7]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 9), control:controllers[8]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 10), control:controllers[9]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 11), control:controllers[10]),
    MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, 12), control:controllers[11]),
  ];

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        leading: ToggleSwitch(),
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 5,
        shadowColor: const Color(0xFF034875),
        surfaceTintColor: Colors.transparent,
        actions: <Widget>[
          LoginButton(),
          CalendarButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back, color: Color(0xff034875),),
            label: 'Year',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back, color: Color(0xff034875),),
            label: 'Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reset_tv, color: Color(0xff034875),),
            label: 'Reset',
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward, color: Color(0xff034875),),
            label: 'Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward, color: Color(0xff034875),),
            label: 'Forward',
          ),
        ],
        backgroundColor: const Color(0xFFEEEEEE),
        selectedItemColor: const Color(0xff034875),
        unselectedItemColor: const Color(0xff034875),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body:
        GridView.count(
          crossAxisCount: AutoScalingFactor.calendarsPerRow(context),
          children: <Widget>[
            yearCalendar[0],
            yearCalendar[1], 
            yearCalendar[2],
            yearCalendar[3],
            yearCalendar[4],
            yearCalendar[5],
            yearCalendar[6],
            yearCalendar[7],
            yearCalendar[8],
            yearCalendar[9],
            yearCalendar[10],
            yearCalendar[11],

          ],
        ),
    );
  }
}

class AutoScalingFactor {
  static const widthThresholdLow = 600;
  static const widthThresholdHigh = 800;
  static const heightThresholdLow = 300;
  static const heightThresholdHigh = 400;

  static bool isLowWidth(BuildContext context) {
    return MediaQuery.of(context).size.width < widthThresholdLow;
  }
  static bool isHighWidth(BuildContext context) {
    return MediaQuery.of(context).size.width < widthThresholdLow;
  }
  static bool isLowHeigth(BuildContext context) {
    return MediaQuery.of(context).size.height < heightThresholdLow;
  }
   static bool isHighHeight(BuildContext context) {
    return MediaQuery.of(context).size.height < heightThresholdLow;
  }

  static double height(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double width(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static double smallTextScaler(BuildContext context) => isLowWidth(context) ? 4 : 8;
  static double largeTextScaler(BuildContext context) => isLowWidth(context) ? 8 : 16;
  static int calendarsPerRow(BuildContext context){
    if (width(context)/height(context) < 9/16){
      return 2;
    }
    else if (width(context)/height(context) < 1){
      return 3;
    }
    else if (width(context)/height(context) < 18/9){
      return 4;
    }
    else {
      return 6;
    }
  }
  static double cellTextScaler(BuildContext context){
    double calendarWidth = MediaQuery.of(context).size.width/calendarsPerRow(context);
    return calendarWidth / 40;
  }
}

class MonthCalendarCard extends Card{
  MonthCalendarCard({this.context, this.initDate, this.control,}):
  super(margin: const EdgeInsets.all(7), child: SfCalendarTheme(data: const SfCalendarThemeData(todayBackgroundColor: Color(0xff034875)), child: MonthCalendar(context: context, initDate: initDate, control:control)));
  final context;
  final DateTime?initDate;
  final CalendarController?control;
}

class MonthCalendar extends SfCalendar {
  MonthCalendar({Key?key, this.context, DateTime?initDate, this.control}): 

  initDate = initDate ?? DateTime(
    DateTime.now().year, 
    DateTime.now().month, 
    DateTime.now().day,
    08, 
    45
  ), 
  super(
    key: key,
    view: CalendarView.month, 
    dataSource: _getCalendarDataSource(),
    backgroundColor: const Color(0xffffffff), 
    initialDisplayDate: initDate, 
    controller: control,
    headerHeight:4.5*AutoScalingFactor.cellTextScaler(context),
    viewNavigationMode: ViewNavigationMode.none,
    headerStyle: CalendarHeaderStyle(
      textStyle: TextStyle(color: Colors.black, fontSize: 2.5*AutoScalingFactor.cellTextScaler(context),),
      textAlign: TextAlign.center,
      backgroundColor: Color(0xFFEEEEEE)),
    monthViewSettings: MonthViewSettings(
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      appointmentDisplayCount: 2,
      monthCellStyle: MonthCellStyle(
        leadingDatesTextStyle: TextStyle(
          color: Colors.black, 
          fontSize: AutoScalingFactor.cellTextScaler(context), 
          height: -1.01,
        ),
        textStyle: TextStyle(
          color: Colors.black, 
          fontSize: AutoScalingFactor.cellTextScaler(context), 
          height: -1.01,
        ),
        trailingDatesTextStyle: TextStyle(
          color: Colors.black, 
          fontSize: AutoScalingFactor.cellTextScaler(context), 
          height: -1.01,
        ),
        leadingDatesBackgroundColor: Color(0xFFEEEEEE),
        trailingDatesBackgroundColor: Color(0xFFEEEEEE),
      ),
    ),
    appointmentTextStyle: TextStyle(
      color: Colors.white,
      fontSize: AutoScalingFactor.cellTextScaler(context),
    ),
    todayHighlightColor: const Color(0xff034875),
    todayTextStyle: TextStyle(
          color: Colors.black, 
          fontSize: AutoScalingFactor.cellTextScaler(context), 
          height: -1.01,
    ),
    selectionDecoration: BoxDecoration(
      border: Border.all(color: const Color(0xff034875), width: 2),
    ),
    viewHeaderHeight: 3*AutoScalingFactor.cellTextScaler(context),
    viewHeaderStyle: ViewHeaderStyle(
      backgroundColor: Colors.white,
      dayTextStyle: TextStyle(
          color: Colors.black, 
          fontSize: 2*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01,
      ),
    )
  );

  final context;
  final DateTime initDate;
  final CalendarController?control;
}

class DataSource extends CalendarDataSource {
 DataSource(List<Appointment> source) {
   appointments = source;
 }
}

DataSource _getCalendarDataSource() {
   List<Appointment> appointments = <Appointment>[];
   appointments.add(Appointment(
     startTime: DateTime.now().subtract(Duration(hours:4*48)),
     endTime: DateTime.now().add(Duration(hours: 48)),
     isAllDay: true,
     subject: 'Meeting',
     color: Colors.blue,
     startTimeZone: '',
     endTimeZone: '',
   ));

   return DataSource(appointments);
}

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeTrackColor: const Color(0xff034875),
      inactiveTrackColor: const Color(0xA0034875),
      trackOutlineColor: MaterialStateProperty.resolveWith((final Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return null;
        }
        return const Color(0x08034875);
        },
      ),
      thumbColor: MaterialStateProperty.resolveWith((final Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return null;
        }
        return Colors.white;
        },
      ),
      onChanged: (bool value) {setState(() {light = value;});
      },
    );
  }
}

class CalendarButton extends StatefulWidget {
  const CalendarButton({super.key});

  @override
  State<CalendarButton> createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.calendar_month),
          color: const Color(0xff034875),
          iconSize: 35,
          onPressed: () {
            setState(() {
            });
          },
        ),
      ],
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State <LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          color: const Color(0xff034875),
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RoutePage()),
            );
          },
        ),
      ],
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
