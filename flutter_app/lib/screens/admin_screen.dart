import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:intl/intl.dart';

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
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Mechatronics',
    'Other'
  ];

  final List<String> _eventTypes = [
    'Workshop',
    'Seminar',
    'Lecture',
    'Further training',
    'Other'
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorScheme.indigo,
              onPrimary: Colors.white,
              surface: AppColorScheme.antiFlash,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorScheme.indigo,
              onPrimary: Colors.white,
              surface: AppColorScheme.antiFlash,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
    }
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
      'event_info_data': _autoTranslate
          ? {
              'name': _inputLanguage == 'EN'
                  ? _nameEnController.text
                  : _nameDeController.text,
              'description': _inputLanguage == 'EN'
                  ? _descriptionEnController.text
                  : _descriptionDeController.text,
              'subject_area': _subjectArea,
              'event_type': _eventType,
            }
          : {
              'name_de': _nameDeController.text,
              'name_en': _nameEnController.text,
              'description_de': _descriptionDeController.text,
              'description_en': _descriptionEnController.text,
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
                if (!_autoTranslate) ...[
                  TextFormField(
                    controller: _nameDeController,
                    decoration:
                        const InputDecoration(labelText: 'Name (German)'),
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
                    decoration: const InputDecoration(
                        labelText: 'Description (German)'),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                  TextFormField(
                    controller: _descriptionEnController,
                    decoration: const InputDecoration(
                        labelText: 'Description (English)'),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                ] else ...[
                  TextFormField(
                    controller: _autoTranslate
                        ? (_inputLanguage == 'EN'
                            ? _nameEnController
                            : _nameDeController)
                        : _nameEnController,
                    decoration: InputDecoration(
                        labelText: _inputLanguage == 'EN'
                            ? 'Name (English)'
                            : 'Name (German)'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _autoTranslate
                        ? (_inputLanguage == 'EN'
                            ? _descriptionEnController
                            : _descriptionDeController)
                        : _descriptionEnController,
                    decoration: InputDecoration(
                        labelText: _inputLanguage == 'EN'
                            ? 'Description (English)'
                            : 'Description (German)'),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                ],
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
                            decoration: InputDecoration(
                              labelText: 'Date',
                              prefixIcon: Icon(Icons.calendar_today),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () =>
                                    dayControllers['date']!.clear(),
                              ),
                            ),
                            readOnly: true,
                            onTap: () =>
                                _selectDate(context, dayControllers['date']!),
                            validator: (value) =>
                                value!.isEmpty ? 'Please select a date' : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['startTime'],
                                  decoration: InputDecoration(
                                    labelText: 'Start Time',
                                    prefixIcon: Icon(Icons.access_time),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () =>
                                          dayControllers['startTime']!.clear(),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectTime(
                                      context, dayControllers['startTime']!),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please select start time'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['endTime'],
                                  decoration: InputDecoration(
                                    labelText: 'End Time',
                                    prefixIcon: Icon(Icons.access_time),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () =>
                                          dayControllers['endTime']!.clear(),
                                    ),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectTime(
                                      context, dayControllers['endTime']!),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please select end time'
                                      : null,
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
