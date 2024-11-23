import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:skill_forge/screens/login_screen.dart' as login;
import 'package:skill_forge/screens/admin_screen.dart' as admin;
import 'package:skill_forge/utils/color_scheme.dart';
import 'monthPage.dart';
import 'weekPage.dart';


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
      title: 'Skill Forge',
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColorScheme.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Skill Forge'),
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
    _checkAdminStatus();
    if (DateTime.now().hour > 18 || DateTime.now().hour <= 6){
      _ToggleSwitchState.light = true;
      AppColorScheme.setDarkmode(true);
    }

  bool _isAdmin = false;

  Future<void> _checkAdminStatus() async {
    await login.UserState().loadUserData();
    setState(() {
      _isAdmin = login.UserState().isAdmin ?? false;
    });
  }
  
  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        for (var i = 0; i < 12; i++) {
          for (var j = 0; j < 12; j++) {
            controllers[i].backward!();
          }
        }
      } else if (index == 4) {
        for (var i = 0; i < 12; i++) {
          for (var j = 0; j < 12; j++) {
            controllers[i].forward!();
          }
        }
      } else if (index == 3) {
        for (var i = 0; i < 12; i++) {
          controllers[i].forward!();
        }
      } else if (index == 1) {
        for (var i = 0; i < 12; i++) {
          controllers[i].backward!();
        }
      } else {
        for (var i = 0; i < 12; i++) {
          controllers[i].displayDate = DateTime(DateTime.now().year, i + 1);
        }
      }
    });
  }

  dynamic refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final yearCalendar = <MonthCalendarCard>[
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 1),
          control: controllers[0]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 2),
          control: controllers[1]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 3),
          control: controllers[2]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 4),
          control: controllers[3]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 5),
          control: controllers[4]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 6),
          control: controllers[5]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 7),
          control: controllers[6]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 8),
          control: controllers[7]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 9),
          control: controllers[8]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 10),
          control: controllers[9]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 11),
          control: controllers[10]),
      MonthCalendarCard(
          context: context,
          initDate: DateTime(DateTime.now().year, 12),
          control: controllers[11]),
    ];
    return Scaffold(
      backgroundColor: AppColorScheme.ownWhite,
      appBar: AppBar(
        leading: ToggleSwitch(notifyParent: refresh),
        backgroundColor: AppColorScheme.antiFlash,
        elevation: 5,
        shadowColor: AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
        actions: <Widget>[
          if (_isAdmin) AdminButon(),
          LoginButton(),
          WeekButton(),
          MonthButton(),
        ],
      ),
      bottomNavigationBar: MonthNavigationBar(onTapped: _onItemTapped, selectedIndex: _selectedIndex),
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

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double smallTextScaler(BuildContext context) =>
      isLowWidth(context) ? 4 : 8;
  static double largeTextScaler(BuildContext context) =>
      isLowWidth(context) ? 8 : 16;
  static int calendarsPerRow(BuildContext context) {
    if (width(context) / height(context) < 9 / 16) {
      return 2;
    } else if (width(context) / height(context) < 1) {
      return 3;
    } else if (width(context) / height(context) < 18 / 9) {
      return 4;
    } else {
      return 6;
    }
  }

  static double cellTextScaler(BuildContext context) {
    double calendarWidth =
        MediaQuery.of(context).size.width / calendarsPerRow(context);
    return calendarWidth / 40;
  }
}

class MonthCalendarCard extends Card{
  MonthCalendarCard({super.key, required this.context, this.initDate, this.control, this.factorScaling = 1, this.cellOffset = 0,}):
  super(margin: const EdgeInsets.all(7), child: SfCalendarTheme(data: SfCalendarThemeData(todayBackgroundColor:  AppColorScheme.indigo), child: MonthCalendar(context: context, initDate: initDate, control: control, factorScaling: factorScaling, cellOffset: cellOffset,)));
  final BuildContext context;
  final DateTime?initDate;
  final CalendarController?control;
  final double factorScaling; 
  final double cellOffset;
}

class MonthCalendar extends SfCalendar {
  MonthCalendar({super.key, required this.context, DateTime?initDate, this.control, required this.factorScaling, required this.cellOffset,}): 

  initDate = initDate ?? DateTime(
    DateTime.now().year, 
    DateTime.now().month, 
    DateTime.now().day,
    08, 
    45
  ), 
  super(
    view: CalendarView.month, 
    firstDayOfWeek: 1,
    dataSource: _getCalendarDataSource(),
    backgroundColor: AppColorScheme.ownWhite, 
    initialDisplayDate: initDate, 
    controller: control,
    headerHeight:factorScaling*4.5*AutoScalingFactor.cellTextScaler(context),
    viewNavigationMode: ViewNavigationMode.none,
    headerStyle: CalendarHeaderStyle(
      textStyle: TextStyle(color: AppColorScheme.ownBlack, fontSize: factorScaling*2.5*AutoScalingFactor.cellTextScaler(context),),
      textAlign: TextAlign.center,
      backgroundColor: AppColorScheme.antiFlash),
    monthViewSettings: MonthViewSettings(
      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      appointmentDisplayCount: 2,
      monthCellStyle: MonthCellStyle(
        leadingDatesTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
        ),
        textStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
        ),
        trailingDatesTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
        ),
        leadingDatesBackgroundColor: AppColorScheme.antiFlash,
        trailingDatesBackgroundColor: AppColorScheme.antiFlash,
      ),
    ),
    appointmentTextStyle: TextStyle(
      color: AppColorScheme.ownWhite,
      fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context),
    ),
    todayHighlightColor: AppColorScheme.indigo,
    todayTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
    ),
    selectionDecoration: BoxDecoration(
      border: Border.all(color:  AppColorScheme.indigo, width: 2),
    ),
    viewHeaderHeight: factorScaling*3*AutoScalingFactor.cellTextScaler(context),
    viewHeaderStyle: ViewHeaderStyle(
      backgroundColor:  AppColorScheme.ownWhite,
      dayTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*2*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
      ),
    )
  );

  final BuildContext context;
  final DateTime initDate;
  final CalendarController?control;
  final double factorScaling;
  final double cellOffset;
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource() {
   List<Appointment> appointments = <Appointment>[];
   appointments.add(Appointment(
     startTime: DateTime.now().subtract(Duration(hours:1)),
     endTime: DateTime.now().add(Duration(hours:1)),
     isAllDay: true,
     subject: 'Meeting',
     color: Colors.blue,
     startTimeZone: '',
     endTimeZone: '',
   ));

   return DataSource(appointments);
}

class ToggleSwitch extends StatefulWidget {
  final Function() notifyParent;
  const ToggleSwitch({super.key, required this.notifyParent});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  static bool light = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeTrackColor: AppColorScheme.indigo,
      inactiveTrackColor: AppColorScheme.slate,
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return const Color(0x66748590);
        },
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return AppColorScheme.ownWhite;
        },
      ),
      thumbIcon: WidgetStateProperty.resolveWith((final Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return  Icon(Icons.light_mode, color: AppColorScheme.indigo);
        }
        return Icon(Icons.dark_mode, color: AppColorScheme.indigo);
        },
      ),
      onChanged: (bool value) {
        setState(() {
          light = value;
          AppColorScheme.setDarkmode(value);
          widget.notifyParent();
        });
      },
    );
  }
}

class MonthButton extends StatefulWidget {
  MonthButton({super.key});

  @override
  State<MonthButton> createState() => _MonthButtonState();
}

class _MonthButtonState extends State<MonthButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.calendar_month_rounded),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MonthPage()),
            );
          },
        ),
      ],
    );
  }
}

class LoginButton extends StatefulWidget {
  LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const login.LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}

class AdminButon extends StatefulWidget {
  AdminButon({super.key});

  @override
  State<AdminButon> createState() => _AdminButonState();
}

class _AdminButonState extends State<AdminButon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.library_add),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const admin.AdminEventScreen()),
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

class MonthNavigationBar extends BottomNavigationBar{
  MonthNavigationBar({super.key, required this.onTapped(int index), required this.selectedIndex,}):
  super(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_back, color: AppColorScheme.indigo,),
        label: 'Year',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_back, color: AppColorScheme.indigo,),
        label: 'Month',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.reset_tv, color: AppColorScheme.indigo,),
        label: 'Reset',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_forward, color: AppColorScheme.indigo,),
        label: 'Month',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_forward, color: AppColorScheme.indigo,),
        label: 'Year',
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

class WeekCalendarCard extends Card{
  WeekCalendarCard({super.key, required this.context, this.initDate, this.control, this.factorScaling = 1, this.cellOffset = 0,}):
  super(margin: const EdgeInsets.all(7), child: SfCalendarTheme(data: SfCalendarThemeData(todayBackgroundColor:  AppColorScheme.indigo), child: WeekCalendar(context: context, initDate: initDate, control: control, factorScaling: factorScaling, cellOffset: cellOffset,)));
  final BuildContext context;
  final DateTime?initDate;
  final CalendarController?control;
  final double factorScaling; 
  final double cellOffset;
}

class WeekCalendar extends SfCalendar {
  WeekCalendar({super.key, required this.context, DateTime?initDate, this.control, required this.factorScaling, required this.cellOffset,}): 

  initDate = initDate ?? DateTime(
    DateTime.now().year, 
    DateTime.now().month, 
    DateTime.now().day,
    08, 
    45
  ), 
  super(
    view: CalendarView.week, 
    firstDayOfWeek: 1,
    dataSource: _getCalendarDataSource(),
    backgroundColor: AppColorScheme.ownWhite, 
    timeSlotViewSettings: TimeSlotViewSettings(
      timeTextStyle: TextStyle(color: AppColorScheme.ownBlack,)
    ),
    initialDisplayDate: initDate, 
    controller: control,
    headerHeight:factorScaling*6*AutoScalingFactor.cellTextScaler(context),
    viewNavigationMode: ViewNavigationMode.none,
    headerStyle: CalendarHeaderStyle(
      textStyle: TextStyle(color: AppColorScheme.ownBlack, fontSize: factorScaling*2.5*AutoScalingFactor.cellTextScaler(context),),
      textAlign: TextAlign.center,
      backgroundColor: AppColorScheme.antiFlash),
    appointmentTextStyle: TextStyle(
      color: AppColorScheme.ownWhite,
      fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context),
    ),
    todayHighlightColor: AppColorScheme.indigo,
    todayTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
    ),
    selectionDecoration: BoxDecoration(
      border: Border.all(color:  AppColorScheme.indigo, width: 2),
    ),
    viewHeaderHeight: factorScaling*8*AutoScalingFactor.cellTextScaler(context),
    viewHeaderStyle: ViewHeaderStyle(
      backgroundColor: AppColorScheme.ownWhite,
      dayTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*2*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
      ),
      dateTextStyle: TextStyle(
          color: AppColorScheme.ownBlack, 
          fontSize: factorScaling*2*AutoScalingFactor.cellTextScaler(context), 
          height: -1.01 + cellOffset,
      ),
    )
  );

  final BuildContext context;
  final DateTime initDate;
  final CalendarController?control;
  final double factorScaling;
  final double cellOffset;
}

class WeekNavigationBar extends BottomNavigationBar{
  WeekNavigationBar({super.key, required this.onTapped(int index), required this.selectedIndex,}):
  super(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_back, color: AppColorScheme.indigo,),
        label: 'Week',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.reset_tv, color: AppColorScheme.indigo,),
        label: 'Reset',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.arrow_forward, color: AppColorScheme.indigo,),
        label: 'Week',
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

class WeekButton extends StatefulWidget {
  WeekButton({super.key});

  @override
  State<WeekButton> createState() => _WeekButtonState();
}

class _WeekButtonState extends State<WeekButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.calendar_view_week_rounded),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeekPage()),
            );
          },
        ),
      ],
    );
  }
}
