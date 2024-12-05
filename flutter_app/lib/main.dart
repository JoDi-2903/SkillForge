import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/utils/buttons.dart';
import 'package:skill_forge/utils/interfaces.dart';
import 'package:skill_forge/utils/filter_dialog.dart';

import 'package:skill_forge/utils/holidays.dart';
import 'package:universal_io/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static Locale get language => _MyHomePageState.language;

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

  static Locale language =
      AppStrings.checkLanguage(); //Locale(AppStrings.german);
  @override
  void initState() {
    for (var i = 0; i < 12; i++) {
      controllers[i] = CalendarController();
      controllers[i].displayDate = DateTime(DateTime.now().year, i + 1);
    }
    super.initState();

    if (DateTime.now().hour > 18 || DateTime.now().hour <= 6) {
      AppColorScheme.setDarkmode(true);
    }
    _checkAdminStatus();
    refresh();
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
    AppStrings.refreshLanguage(language.toString());
  }

  dynamic setLocale(String code) {
    language = Locale(code);
    refresh();
  }

  dynamic setRegion(Region code) {
    region = code;
    refresh();
  }

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isAdmin = false;
  bool _isUserLoggedIn = false;
  String _username = '';

  Future<void> _checkAdminStatus() async {
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _isAdmin = decodedToken['is_admin'];
        _isUserLoggedIn = decodedToken['username'] != null;
        _username = decodedToken['username'] ?? '';
      });
    } else {
      setState(() {
        _isAdmin = false;
        _isUserLoggedIn = false;
        _username = '';
      });
    }
  }

  void _handleLogout() async {
    await secureStorage.delete(key: 'jwt_token');
    setState(() {
      _isAdmin = false;
      _isUserLoggedIn = false;
      _username = '';
    });

    // Show logout dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                '${AppStrings.logoutSuccessful}!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColorScheme.ownBlack,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> _filters = {
    'user_id': null,
    'event_type': [],
    'subject_area': [],
  };

  // Function to open the filter dialog
  void _openFilterDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterDialog(
        initialFilters: _filters,
      ),
    );

    if (result != null) {
      setState(() {
        _filters = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final yearCalendar = <MonthCalendarCard>[
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 1),
        control: controllers[0],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 2),
        control: controllers[1],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 3),
        control: controllers[2],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 4),
        control: controllers[3],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 5),
        control: controllers[4],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 6),
        control: controllers[5],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 7),
        control: controllers[6],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 8),
        control: controllers[7],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 9),
        control: controllers[8],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 10),
        control: controllers[9],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 11),
        control: controllers[10],
        filters: _filters,
      ),
      MonthCalendarCard(
        context: context,
        initDate: DateTime(DateTime.now().year, 12),
        control: controllers[11],
        filters: _filters,
      ),
    ];

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale(AppStrings.chinese),
        Locale(AppStrings.english),
        Locale(AppStrings.german),
      ],
      locale: language,
      home: Scaffold(
        backgroundColor: AppColorScheme.ownWhite,
        appBar: AppBar(
            leading: ToggleSwitch(notifyParent: refresh),
            backgroundColor: AppColorScheme.antiFlash,
            elevation: 5,
            shadowColor: AppColorScheme.indigo,
            surfaceTintColor: Colors.transparent,
            actions: <Widget>[
              if (_isAdmin) AdminButton(),
              LoginButton(
                isUserLoggedIn: _isUserLoggedIn,
                onLogout: _handleLogout,
                onLoginStatusChanged: _checkAdminStatus,
              ),
              LanguageButton(language: setLocale),
              RegionButton(region: setRegion),
              WeekButton(filters: _filters),
              MonthButton(filters: _filters),
            ]),
        bottomNavigationBar: MonthNavigationBar(
            onTapped: _onItemTapped, selectedIndex: _selectedIndex),
        body: GridView.count(
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
        floatingActionButton: FloatingActionButton(
          onPressed: _openFilterDialog,
          backgroundColor: AppColorScheme.indigo,
          child: Icon(Icons.filter_alt, color: AppColorScheme.ownWhite),
        ),
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
