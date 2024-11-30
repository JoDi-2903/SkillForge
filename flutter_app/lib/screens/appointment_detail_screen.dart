import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event {
  final String dayId;
  final String subject;
  final String description;
  /*final DateTime startTime;
  final DateTime endTime;
  final String location;*/
  final Color color;
  Event(this.dayId, this.subject, this.description,
      /*this.startTime, this.endTime, this.location,*/ this.color);
}

Future<Event> _getEventInfo(String dayId) async {
  String language = MyApp.language.languageCode.toUpperCase();
  if (language == 'ZH') {
    language = 'EN';
  }

  Map<String, String> params = {
    'language': language,
    'day_id': dayId,
  };

  Uri uri = Uri.http('127.0.0.1:5000', '/api/event-details', params);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    dynamic data = json.decode(response.body);

    Color color;
    switch (data['subject_area']) {
      case 'Computer Science':
        color = AppColorScheme.computerScience;
        break;
      case 'Electrical Engineering':
        color = AppColorScheme.electricalEngineering;
        break;
      case 'Mechanical Engineering':
        color = AppColorScheme.mechanicalEngineering;
        break;
      case 'Mechatronics':
        color = AppColorScheme.mechatronics;
        break;
      default:
        color = AppColorScheme.otherSubject;
    }

    //Try to access location does not work
    /*
    String location;
    String locations = data['locations'];
    location = locations[0];
    */

    Event eventInfo = Event(dayId, data['title'], data['description'], color);
    return eventInfo;
  } else {
    throw Exception('Failed to load details');
  }
}

class AppointmentDetailScreen extends StatelessWidget {
  final String dayId;

  const AppointmentDetailScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event>(
        future: _getEventInfo(dayId), // Fetch the data source
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Build your appointment detail screen here
            return Scaffold(
              appBar: AppBar(
                title: const Text('Appointment Details'),
                centerTitle: true,
                backgroundColor: snapshot.data?.color,
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
                        (snapshot.data?.subject)!,
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
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
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
                        DateFormat('kk:mm').format(DateTime.now()),
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
                        DateFormat('kk:mm').format(DateTime.now()),
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
                        'hier',
                        //(snapshot.data?.location)!,
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
                      Flexible(
                        child: Text(
                          (snapshot.data?.description)!,
                          style: TextStyle(
                            color: AppColorScheme.ownBlack,
                          ),
                        ),
                      )
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
          } else {
            // In case there's no data
            return const Center(child: Text('No details available'));
          }
        });
  }
}
