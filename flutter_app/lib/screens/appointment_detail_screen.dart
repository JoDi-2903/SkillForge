import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String trainingId;

  const AppointmentDetailScreen({super.key, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    // Build your appointment detail screen here
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Center(
        child: Text('Training ID: $trainingId'),
      ),
    );
  }
}
