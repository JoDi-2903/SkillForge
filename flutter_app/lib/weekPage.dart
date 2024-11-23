import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'buttons.dart';
import 'main.dart';

class WeekPage extends StatefulWidget{
  const WeekPage({super.key});

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage>{
  int _selectedIndex = 0;
  int weekOffset = 0;
  int monthOffset = 0;
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
        controller.backward!(); 
      }
      else if (index == 2){
        controller.forward!();
      }
      else{ 
        controller.displayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
        backgroundColor: AppColorScheme.antiFlash,
        elevation: 5,
        shadowColor:  AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
      ),
      body: WeekCalendarCard(context: context, initDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,), control: controller, factorScaling: 1.5, cellOffset: 1.01,),
      bottomNavigationBar: WeekNavigationBar(onTapped: _onItemTapped, selectedIndex: _selectedIndex,)
    );
  }
}