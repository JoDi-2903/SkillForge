import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'buttons.dart';
import 'main.dart';

class MonthPage extends StatefulWidget{
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage>{
  int _selectedIndex = 0;
  late CalendarController controller;

  @override
  void initState(){
    controller = CalendarController();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0){
        for (var j = 0; j < 12; j++){
          controller.backward!();
        }
      }
      else if (index == 4){
        for (var j = 0; j < 12; j++){
          controller.forward!();
        }
      }
      else if (index == 3){  
        controller.forward!();
      }
      else if (index == 1){
        controller.backward!();
      }
      else{ 
        controller.displayDate = DateTime(DateTime.now().year, DateTime.now().month);
      }
    });
  }

  dynamic goBack(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColorScheme.ownWhite,
      appBar: AppBar(
        leading: ButtonBack(backFunction: goBack),
        backgroundColor:  AppColorScheme.antiFlash,
        elevation: 5,
        shadowColor:  AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
      ),
      body: MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, DateTime.now().month), control: controller, factorScaling: 2, cellOffset: 1.01,),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}