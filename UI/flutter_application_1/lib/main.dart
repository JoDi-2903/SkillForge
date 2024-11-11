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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(
            fontSize: AutoScalingFactor.largeTextScaler(context)
          ),
        ),
      ),
      body:
        GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            Card(
              child: SfCalendar(
                view: CalendarView.month, 
                initialDisplayDate: DateTime(DateTime.now().year, 1),
                headerStyle: const CalendarHeaderStyle(
                  textStyle: TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.blue),
                monthViewSettings: MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(color: Colors.black, fontSize: AutoScalingFactor.smallTextScaler(context), height: -1.01)
                  ),
                ),
  
              ),
            ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 2)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 3)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 4)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 5)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 6)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 7)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 8)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 9)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 10)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 11)),
              ),
            Card(
              child:
              SfCalendar(view: CalendarView.month, initialDisplayDate: DateTime(DateTime.now().year, 12)),
              ),

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