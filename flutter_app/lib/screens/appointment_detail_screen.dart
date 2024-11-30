import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/main.dart';
import 'package:skill_forge/screens/login_screen.dart' as login;
import 'package:skill_forge/utils/languages.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String dayId;

  const AppointmentDetailScreen({Key? key, required this.dayId})
      : super(key: key);

  @override
  _AppointmentDetailScreenState createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  Map<String, dynamic>? eventDetails;
  bool isLoading = true;
  bool isRegistered = false;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
    _checkUserLoginStatus();
  }

  Future<void> _fetchEventDetails() async {
    // Prepare the language parameter
    String language = MyApp.language.languageCode.toUpperCase();
    if (language == 'ZH') {
      language = 'EN';
    }

    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:5000/api/event-details?day_id=${widget.dayId}&language=$language'));
      if (response.statusCode == 200) {
        setState(() {
          eventDetails = json.decode(response.body);
          isLoading = false;
        });
        if (isUserLoggedIn) {
          _checkRegistrationStatus();
        }
      } else {
        _showErrorSnackBar(AppStrings.failedToLoadEventDetails);
      }
    } catch (e) {
      _showErrorSnackBar(AppStrings.networkError);
    }
  }

  void _checkUserLoginStatus() {
    setState(() {
      isUserLoggedIn = login.UserState().username != null;
    });
  }

  Future<void> _checkRegistrationStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:5000/api/event-registration-status?training_id=${eventDetails?['training_id']}&user_id=${login.UserState().userId}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isRegistered = data['is_registered'];
        });
      } else {
        _showErrorSnackBar(AppStrings.failedToCheckRegistrationStatus);
      }
    } catch (e) {
      _showErrorSnackBar(AppStrings.networkError);
    }
  }

  Future<void> _registerForEvent() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/book-event'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'training_id': eventDetails?['training_id'],
          'user_id': login.UserState().userId,
        }),
      );
      final data = json.decode(response.body);
      if (data['success']) {
        _showSuccessSnackBar(AppStrings.registrationSuccessful);
        setState(() {
          isRegistered = true;
        });
      } else {
        _showErrorSnackBar(data['error'] ?? AppStrings.registrationFailed);
      }
    } catch (e) {
      _showErrorSnackBar(AppStrings.networkError);
    }
  }

  Future<void> _cancelRegistration() async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:5000/api/cancel-event-registration'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'training_id': eventDetails?['training_id'],
          'user_id': login.UserState().userId,
        }),
      );
      final data = json.decode(response.body);
      if (data['success']) {
        _showSuccessSnackBar(AppStrings.cancellationSuccessful);
        setState(() {
          isRegistered = false;
        });
      } else {
        _showErrorSnackBar(data['error'] ?? AppStrings.cancellationFailed);
      }
    } catch (e) {
      _showErrorSnackBar(AppStrings.networkError);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appointmentDetails),
        backgroundColor: AppColorScheme.indigo,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : eventDetails == null
              ? Center(child: Text(AppStrings.noEventDetails))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventDetails?['title'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColorScheme.ownBlack,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        eventDetails?['description'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColorScheme.ownBlack,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildEventInfo(),
                      SizedBox(height: 24),
                      isUserLoggedIn
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColorScheme.indigo,
                              ),
                              onPressed: isRegistered
                                  ? _cancelRegistration
                                  : _registerForEvent,
                              child: Text(
                                isRegistered
                                    ? AppStrings.cancelRegistration
                                    : AppStrings.registerForEvent,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColorScheme.indigo,
                              ),
                              onPressed: null,
                              child: Text(AppStrings.loginRequired),
                            ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEventInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(AppStrings.eventType, eventDetails?['event_type']),
        _buildInfoRow(AppStrings.subjectArea, eventDetails?['subject_area']),
        _buildInfoRow(
          AppStrings.participants,
          '${eventDetails?['current_participants']}/${eventDetails?['max_participants']}',
        ),
        SizedBox(height: 16),
        Text(
          AppStrings.eventDates,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColorScheme.ownBlack,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (eventDetails?['event_dates'] as List).length,
          itemBuilder: (context, index) {
            final dateInfo = eventDetails?['event_dates'][index];
            return ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: AppColorScheme.indigo,
              ),
              title: Text(
                '${dateInfo['date']} ${dateInfo['start_time']} - ${dateInfo['end_time']}',
                style: TextStyle(color: AppColorScheme.ownBlack),
              ),
              subtitle: Text(
                '${dateInfo['location']}, ${dateInfo['federal_state']}',
                style: TextStyle(color: AppColorScheme.ownBlack),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColorScheme.ownBlack,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 16,
                color: AppColorScheme.ownBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
