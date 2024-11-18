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

  @override
  void initState(){
    super.initState();
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
      body: MonthCalendarCard(context: context, initDate: DateTime(DateTime.now().year, DateTime.now().month)),
    );
  }
}