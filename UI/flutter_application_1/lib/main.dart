import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      else if (index == 2){
        for (var i = 0; i < 12; i++) {  
          for (var j = 0; j < 12; j++){
            controllers[i].forward!();
          }
        }
      }
      else{
        for (var i = 0; i < 12; i++) {  
          controllers[i].displayDate = DateTime(DateTime.now().year, i+1);
        }
      }
      print(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    final yearCalendar = <Card>[
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 1),control:controllers[0])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 2),control:controllers[1])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 3),control:controllers[2])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 4),control:controllers[3])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 5),control:controllers[4])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 6),control:controllers[5])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 7),control:controllers[6])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 8),control:controllers[7])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 9),control:controllers[8])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 10),control:controllers[9])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 11),control:controllers[10])),
    Card(child: MonthCalendar(initDate: DateTime(DateTime.now().year, 12),control:controllers[11])),
  ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reset_tv),
            label: 'Reset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Forward',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body:
        GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            /*Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: SfCalendar(
                view: CalendarView.month, 
                controller: _controller,
                initialDisplayDate: DateTime(DateTime.now().year, 1),
                headerStyle: const CalendarHeaderStyle(
                  textStyle: TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.blue),
                //backgroundColor: Colors.teal,
                monthViewSettings: MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(color: Colors.black, fontSize: AutoScalingFactor.smallTextScaler(context), height: -1.01)
                  ),
                ),
  
              ),
            ),*/
            ///////////////////////////////////////////////////
            //Currently Placeholder, probably better to inherit
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
    print(MediaQuery.of(context).size.height);
    return MediaQuery.of(context).size.height < heightThresholdLow;
  }
   static bool isHighHeight(BuildContext context) {
    return MediaQuery.of(context).size.height < heightThresholdLow;
  }

  static double smallTextScaler(BuildContext context) => isLowHeigth(context) ? 4 : 8;
  static double largeTextScaler(BuildContext context) => isLowHeigth(context) ? 8 : 16;
}

class MonthCalendar extends SfCalendar {
  MonthCalendar({DateTime?initDate, this.control}): 
  initDate = initDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
  08, 45), 
  super(view: CalendarView.month, initialDisplayDate: initDate, controller: control);
  final DateTime initDate;
  final CalendarController?control;
}