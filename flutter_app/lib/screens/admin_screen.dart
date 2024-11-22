import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_forge/utils/color_scheme.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({Key? key}) : super(key: key);

  @override
  _AdminEventScreenState createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for event information
  final _nameDeController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descriptionDeController = TextEditingController();
  final _descriptionEnController = TextEditingController();

  // Controllers for training course details
  final _minParticipantsController = TextEditingController(text: '7');
  final _maxParticipantsController = TextEditingController(text: '25');

  // Event day controllers
  final List<Map<String, TextEditingController>> _eventDayControllers = [];

  bool _autoTranslate = false;
  String _inputLanguage = 'EN';
  String _subjectArea = 'Other';
  String _eventType = 'Other';

  final List<String> _subjectAreas = [
    'Other',
    'IT',
    'Management',
    'Communication',
    'Technical Skills'
  ];

  final List<String> _eventTypes = [
    'Other',
    'Workshop',
    'Seminar',
    'Training',
    'Conference'
  ];

  @override
  void initState() {
    super.initState();
    // Add initial event day
    _addEventDay();
  }

  void _addEventDay() {
    setState(() {
      _eventDayControllers.add({
        'date': TextEditingController(),
        'startTime': TextEditingController(),
        'endTime': TextEditingController(),
        'location': TextEditingController(),
        'federalState': TextEditingController(),
      });
    });
  }

  void _removeEventDay(int index) {
    setState(() {
      _eventDayControllers[index]['date']!.dispose();
      _eventDayControllers[index]['startTime']!.dispose();
      _eventDayControllers[index]['endTime']!.dispose();
      _eventDayControllers[index]['location']!.dispose();
      _eventDayControllers[index]['federalState']!.dispose();
      _eventDayControllers.removeAt(index);
    });
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    // Prepare event data according to backend API
    final eventData = {
      'auto_translate': _autoTranslate,
      'input_language': _inputLanguage,
      'training_course_data': {
        'min_participants': int.parse(_minParticipantsController.text),
        'max_participants': int.parse(_maxParticipantsController.text),
      },
      'event_info_data': {
        'name': _autoTranslate
            ? (_inputLanguage == 'EN'
                ? _nameEnController.text
                : _nameDeController.text)
            : null,
        'description': _autoTranslate
            ? (_inputLanguage == 'EN'
                ? _descriptionEnController.text
                : _descriptionDeController.text)
            : null,
        'name_de': !_autoTranslate ? _nameDeController.text : null,
        'name_en': !_autoTranslate ? _nameEnController.text : null,
        'description_de':
            !_autoTranslate ? _descriptionDeController.text : null,
        'description_en':
            !_autoTranslate ? _descriptionEnController.text : null,
        'subject_area': _subjectArea,
        'event_type': _eventType,
      },
      'event_days_data': _eventDayControllers
          .map((dayControllers) => {
                'event_date': dayControllers['date']!.text,
                'start_time': dayControllers['startTime']!.text,
                'end_time': dayControllers['endTime']!.text,
                'event_location': dayControllers['location']!.text,
                'location_federal_state': dayControllers['federalState']!.text,
              })
          .toList(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/admin/create-event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(eventData),
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Event created successfully with ID: ${responseBody['training_id']}'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form after successful creation
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['error'] ?? 'Event creation failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Event',
            style: TextStyle(color: AppColorScheme.ownBlack)),
        backgroundColor: AppColorScheme.antiFlash,
        iconTheme: IconThemeData(color: AppColorScheme.indigo),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Translation Settings
                SwitchListTile(
                  title: const Text('Auto Translate'),
                  value: _autoTranslate,
                  onChanged: (bool value) {
                    setState(() {
                      _autoTranslate = value;
                    });
                  },
                ),
                if (_autoTranslate)
                  DropdownButtonFormField<String>(
                    value: _inputLanguage,
                    decoration:
                        const InputDecoration(labelText: 'Input Language'),
                    items: ['EN', 'DE'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _inputLanguage = newValue!;
                      });
                    },
                  ),
                // Name and Description Fields
                TextFormField(
                  controller: _nameDeController,
                  decoration: const InputDecoration(labelText: 'Name (German)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _nameEnController,
                  decoration:
                      const InputDecoration(labelText: 'Name (English)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _descriptionDeController,
                  decoration:
                      const InputDecoration(labelText: 'Description (German)'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: _descriptionEnController,
                  decoration:
                      const InputDecoration(labelText: 'Description (English)'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                // Additional Event Details
                DropdownButtonFormField<String>(
                  value: _subjectArea,
                  decoration: const InputDecoration(labelText: 'Subject Area'),
                  items: _subjectAreas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _subjectArea = newValue!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _eventType,
                  decoration: const InputDecoration(labelText: 'Event Type'),
                  items: _eventTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _eventType = newValue!;
                    });
                  },
                ),
                // Participant Limits
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minParticipantsController,
                        decoration: const InputDecoration(
                            labelText: 'Min Participants'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter min participants' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxParticipantsController,
                        decoration: const InputDecoration(
                            labelText: 'Max Participants'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter max participants' : null,
                      ),
                    ),
                  ],
                ),
                // Event Days Section
                const SizedBox(height: 16),
                Text('Event Days',
                    style: Theme.of(context).textTheme.titleMedium),
                ...List.generate(_eventDayControllers.length, (index) {
                  final dayControllers = _eventDayControllers[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: dayControllers['date'],
                            decoration: const InputDecoration(
                                labelText: 'Date (YYYY-MM-DD)'),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter date' : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['startTime'],
                                  decoration: const InputDecoration(
                                      labelText: 'Start Time'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter start time'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['endTime'],
                                  decoration: const InputDecoration(
                                      labelText: 'End Time'),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter end time' : null,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: dayControllers['location'],
                            decoration:
                                const InputDecoration(labelText: 'Location'),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter location' : null,
                          ),
                          TextFormField(
                            controller: dayControllers['federalState'],
                            decoration: const InputDecoration(
                                labelText: 'Federal State'),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter federal state' : null,
                          ),
                          if (_eventDayControllers.length > 1)
                            TextButton(
                              onPressed: () => _removeEventDay(index),
                              child: const Text('Remove Day'),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: _addEventDay,
                  child: const Text('Add Another Event Day'),
                ),
                // Submit Button
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorScheme.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameDeController.dispose();
    _nameEnController.dispose();
    _descriptionDeController.dispose();
    _descriptionEnController.dispose();
    _minParticipantsController.dispose();
    _maxParticipantsController.dispose();

    for (var dayControllers in _eventDayControllers) {
      dayControllers.forEach((key, controller) {
        controller.dispose();
      });
    }

    super.dispose();
  }
}
