import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_forge/utils/color_scheme.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final Color color;

  const AppointmentDetailScreen({
    super.key,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Build your appointment detail screen here
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Appointment Details')),
        backgroundColor: color,
      ),
      body: Center(
        child: Container(
          child: Column(children: [
            Divider(
              height: 10,
              color: AppColorScheme.ownBlack,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.lightbulb,
                color: AppColorScheme.ownBlack,
                size: 20,
              ),
              Text(
                subject,
                style: TextStyle(
                  color: AppColorScheme.ownBlack,
                ),
              ),
            ]),
            Divider(
              height: 10,
              color: AppColorScheme.ownBlack,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.calendar_month,
                color: AppColorScheme.ownBlack,
                size: 20,
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(startTime),
                style: TextStyle(
                  color: AppColorScheme.ownBlack,
                ),
              ),
            ]),
            Divider(
              height: 10,
              color: AppColorScheme.ownBlack,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.punch_clock,
                color: AppColorScheme.ownBlack,
                size: 20,
              ),
              Text(
                DateFormat('kk:mm').format(startTime),
                style: TextStyle(
                  color: AppColorScheme.ownBlack,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: AppColorScheme.ownBlack,
                size: 20,
              ),
              Text(
                DateFormat('kk:mm').format(endTime),
                style: TextStyle(
                  color: AppColorScheme.ownBlack,
                ),
              ),
            ]),
            Divider(
              height: 10,
              color: AppColorScheme.ownBlack,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.map,
                color: AppColorScheme.ownBlack,
                size: 20,
              ),
              Text(
                location,
                style: TextStyle(
                  color: AppColorScheme.ownBlack,
                ),
              ),
            ]),
            Divider(
              height: 10,
              color: AppColorScheme.ownBlack,
            ),
          ]),
        ),
      ),
      backgroundColor: AppColorScheme.antiFlash,
    );
  }
}
