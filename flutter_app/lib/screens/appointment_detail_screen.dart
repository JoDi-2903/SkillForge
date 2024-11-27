import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String dayId;

  const AppointmentDetailScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context) {
    // Build your appointment detail screen here
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Center(
        child: Text('Day ID: $dayId'),
      ),
    );
  }
}
