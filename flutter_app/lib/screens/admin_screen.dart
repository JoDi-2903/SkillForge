import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:intl/intl.dart';
import 'package:skill_forge/screens/login_screen.dart' as login;
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({Key? key}) : super(key: key);

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isAdmin = false;

  // Controllers for event information
  final _nameDeController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameZhController = TextEditingController();
  final _descriptionDeController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final _descriptionZhController = TextEditingController();

  // Controllers for training course details
  final _minParticipantsController = TextEditingController(text: '7');
  final _maxParticipantsController = TextEditingController(text: '25');

  // Event day controllers
  final List<Map<String, TextEditingController>> _eventDayControllers = [];

  bool _autoTranslate = false;
  String _inputLanguage = 'EN';
  String _subjectArea = 'Other';
  String _eventType = 'Other';

  final List<String> _inputLanguages = ['DE', 'EN', 'ZH'];

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
    _checkAdminStatus();
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
      locale: MyApp.language,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorScheme.indigo,
              onPrimary: AppColorScheme.ownWhite,
              surface: AppColorScheme.antiFlash,
              onSurface: AppColorScheme.ownBlack,
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
        return Localizations(
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: MyApp.language,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColorScheme.indigo,
                secondary: AppColorScheme.lapisLazuli,
                onPrimary: AppColorScheme.ownWhite,
                surface: AppColorScheme.antiFlash,
                onSurface: AppColorScheme.ownBlack,
              ),
            ),
            child: child!,
          ),
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
                  : _inputLanguage == 'DE'
                      ? _nameDeController.text
                      : _nameZhController.text,
              'description': _inputLanguage == 'EN'
                  ? _descriptionEnController.text
                  : _inputLanguage == 'DE'
                      ? _descriptionDeController.text
                      : _descriptionZhController.text,
              'subject_area': _subjectArea,
              'event_type': _eventType,
            }
          : {
              'name_de': _nameDeController.text,
              'name_en': _nameEnController.text,
              'name_zh': _nameZhController.text,
              'description_de': _descriptionDeController.text,
              'description_en': _descriptionEnController.text,
              'description_zh': _descriptionZhController.text,
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
      String? token = await secureStorage.read(key: 'jwt_token');

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/admin/create-event'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(eventData),
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppStrings.eventSuccessful} ${responseBody['training_id']}'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form after successful creation
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(responseBody['error'] ?? AppStrings.eventNotSuccessful),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.networkError2} $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _checkAdminStatus() async {
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        isAdmin = decodedToken['is_admin'];
      });
    } else {
      // Redirect to login screen if token is not found
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const login.LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.accesDenied),
        ),
        body: Center(
          child: Text(AppStrings.notAuthorized),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColorScheme.ownWhite,
      appBar: AppBar(
        backgroundColor: AppColorScheme.antiFlash,
        foregroundColor: AppColorScheme.ownBlack,
        elevation: 5,
        shadowColor: AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppStrings.adminPanel,
          style: TextStyle(color: AppColorScheme.ownBlack),
        ),
        centerTitle: true,
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
                  title: Text(
                    AppStrings.autoTranslate,
                    style: TextStyle(
                      color: AppColorScheme.ownBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: _autoTranslate,
                  onChanged: (bool value) {
                    setState(() {
                      _autoTranslate = value;
                    });
                  },
                  activeColor: AppColorScheme.indigo,
                  activeTrackColor: AppColorScheme.lapisLazuli,
                  inactiveThumbColor: AppColorScheme.battleShip,
                  inactiveTrackColor: AppColorScheme.antiFlash,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                const SizedBox(height: 16),
                // Name and Description Fields
                if (_autoTranslate)
                  DropdownButtonFormField<String>(
                    value: _inputLanguage,
                    decoration: InputDecoration(
                      labelText: AppStrings.autoTranslate,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    dropdownColor: AppColorScheme.ownWhite,
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppColorScheme.indigo),
                    items: _inputLanguages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _inputLanguage = newValue!;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                // Event Names and Descriptions
                if (!_autoTranslate) ...[
                  TextFormField(
                    controller: _nameDeController,
                    decoration: InputDecoration(
                      labelText: AppStrings.nameDE,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterStringDE;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameEnController,
                    decoration: InputDecoration(
                      labelText: AppStrings.nameEN,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterStringEN;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameZhController,
                    decoration: InputDecoration(
                      labelText: AppStrings.nameZH,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterStringZH;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionDeController,
                    decoration: InputDecoration(
                      labelText: AppStrings.descriptionDE,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterDescriptionDE;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionEnController,
                    decoration: InputDecoration(
                      labelText: AppStrings.descriptionEN,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterDescriptionEN;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionZhController,
                    decoration: InputDecoration(
                      labelText: AppStrings.descriptionZH,
                      labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.slate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColorScheme.indigo),
                      ),
                    ),
                    style: TextStyle(color: AppColorScheme.ownBlack),
                    cursorColor: AppColorScheme.indigo,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterDescriptionZH;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  // Auto-Translate Fields
                  if (_inputLanguage == 'DE') ...[
                    TextFormField(
                      controller: _nameDeController,
                      decoration: InputDecoration(
                        labelText: AppStrings.nameDE,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterStringDE;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionDeController,
                      decoration: InputDecoration(
                        labelText: AppStrings.descriptionDE,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterDescriptionDE;
                        }
                        return null;
                      },
                    ),
                  ] else if (_inputLanguage == 'EN') ...[
                    TextFormField(
                      controller: _nameEnController,
                      decoration: InputDecoration(
                        labelText: AppStrings.nameEN,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterStringEN;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionEnController,
                      decoration: InputDecoration(
                        labelText: AppStrings.descriptionEN,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterDescriptionEN;
                        }
                        return null;
                      },
                    ),
                  ] else if (_inputLanguage == 'ZH') ...[
                    TextFormField(
                      controller: _nameZhController,
                      decoration: InputDecoration(
                        labelText: AppStrings.nameZH,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterStringZH;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionZhController,
                      decoration: InputDecoration(
                        labelText: AppStrings.descriptionZH,
                        labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.slate),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColorScheme.indigo),
                        ),
                      ),
                      style: TextStyle(color: AppColorScheme.ownBlack),
                      cursorColor: AppColorScheme.indigo,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.enterDescriptionZH;
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
                // Additional Event Details
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _subjectArea,
                  decoration: InputDecoration(
                    labelText: AppStrings.subjectArea,
                    labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColorScheme.slate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColorScheme.indigo),
                    ),
                  ),
                  dropdownColor: AppColorScheme.ownWhite,
                  style: TextStyle(color: AppColorScheme.ownBlack),
                  icon:
                      Icon(Icons.arrow_drop_down, color: AppColorScheme.indigo),
                  items: _subjectAreas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: AppColorScheme.ownBlack),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _subjectArea = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _eventType,
                  decoration: InputDecoration(
                    labelText: AppStrings.eventType,
                    labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColorScheme.slate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColorScheme.indigo),
                    ),
                  ),
                  dropdownColor: AppColorScheme.ownWhite,
                  style: TextStyle(color: AppColorScheme.ownBlack),
                  icon:
                      Icon(Icons.arrow_drop_down, color: AppColorScheme.indigo),
                  items: _eventTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: AppColorScheme.ownBlack),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _eventType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Participant Limits
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minParticipantsController,
                        decoration: InputDecoration(
                          labelText: AppStrings.minParticipants,
                          labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                          prefixIcon:
                              Icon(Icons.people, color: AppColorScheme.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColorScheme.slate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppColorScheme.indigo),
                          ),
                        ),
                        style: TextStyle(color: AppColorScheme.ownBlack),
                        cursorColor: AppColorScheme.indigo,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? AppStrings.enterMinParticipants
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxParticipantsController,
                        decoration: InputDecoration(
                          labelText: AppStrings.maxParticipants,
                          labelStyle: TextStyle(color: AppColorScheme.ownBlack),
                          prefixIcon:
                              Icon(Icons.people, color: AppColorScheme.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColorScheme.slate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: AppColorScheme.indigo),
                          ),
                        ),
                        style: TextStyle(color: AppColorScheme.ownBlack),
                        cursorColor: AppColorScheme.indigo,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? AppStrings.enterMaxParticipants
                            : null,
                      ),
                    ),
                  ],
                ),
                // Event Days Section
                const SizedBox(height: 16),
                Text(
                  AppStrings.eventDays,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColorScheme.ownBlack,
                      ),
                ),
                ...List.generate(_eventDayControllers.length, (index) {
                  final dayControllers = _eventDayControllers[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColorScheme.slate, width: 1),
                    ),
                    color: AppColorScheme.ownWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: dayControllers['date'],
                            decoration: InputDecoration(
                              labelText: AppStrings.date,
                              labelStyle:
                                  TextStyle(color: AppColorScheme.ownBlack),
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: AppColorScheme.indigo),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear,
                                    color: AppColorScheme.indigo),
                                onPressed: () =>
                                    dayControllers['date']!.clear(),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.slate),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.indigo),
                              ),
                            ),
                            style: TextStyle(color: AppColorScheme.ownBlack),
                            readOnly: true,
                            onTap: () =>
                                _selectDate(context, dayControllers['date']!),
                            validator: (value) =>
                                value!.isEmpty ? AppStrings.selectDate : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['startTime'],
                                  decoration: InputDecoration(
                                    labelText: AppStrings.startTime,
                                    labelStyle: TextStyle(
                                        color: AppColorScheme.ownBlack),
                                    prefixIcon: Icon(Icons.access_time,
                                        color: AppColorScheme.indigo),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear,
                                          color: AppColorScheme.indigo),
                                      onPressed: () =>
                                          dayControllers['startTime']!.clear(),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColorScheme.slate),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColorScheme.indigo),
                                    ),
                                  ),
                                  style:
                                      TextStyle(color: AppColorScheme.ownBlack),
                                  readOnly: true,
                                  onTap: () => _selectTime(
                                      context, dayControllers['startTime']!),
                                  validator: (value) => value!.isEmpty
                                      ? AppStrings.selectStartTime
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: dayControllers['endTime'],
                                  decoration: InputDecoration(
                                    labelText: AppStrings.endTime,
                                    labelStyle: TextStyle(
                                        color: AppColorScheme.ownBlack),
                                    prefixIcon: Icon(Icons.access_time,
                                        color: AppColorScheme.indigo),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear,
                                          color: AppColorScheme.indigo),
                                      onPressed: () =>
                                          dayControllers['endTime']!.clear(),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColorScheme.slate),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColorScheme.indigo),
                                    ),
                                  ),
                                  style:
                                      TextStyle(color: AppColorScheme.ownBlack),
                                  readOnly: true,
                                  onTap: () => _selectTime(
                                      context, dayControllers['endTime']!),
                                  validator: (value) => value!.isEmpty
                                      ? AppStrings.selectEndTime
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: dayControllers['location'],
                            decoration: InputDecoration(
                              labelText: AppStrings.location,
                              labelStyle:
                                  TextStyle(color: AppColorScheme.ownBlack),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.slate),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.indigo),
                              ),
                            ),
                            style: TextStyle(color: AppColorScheme.ownBlack),
                            validator: (value) => value!.isEmpty
                                ? AppStrings.enterLocation
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: dayControllers['federalState'],
                            decoration: InputDecoration(
                              labelText: AppStrings.federalState,
                              labelStyle:
                                  TextStyle(color: AppColorScheme.ownBlack),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.slate),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: AppColorScheme.indigo),
                              ),
                            ),
                            style: TextStyle(color: AppColorScheme.ownBlack),
                            validator: (value) => value!.isEmpty
                                ? AppStrings.enterFederalState
                                : null,
                          ),
                          if (_eventDayControllers.length > 1)
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                              ),
                              onPressed: () => _removeEventDay(index),
                              child: Text(AppStrings.removeDay),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorScheme.lapisLazuli,
                    foregroundColor: AppColorScheme.ownWhite,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _addEventDay,
                  child: Text(
                    AppStrings.addEventDay,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Submit Button
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorScheme.indigo,
                    foregroundColor: AppColorScheme.ownWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    AppStrings.createEvent,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
    _nameZhController.dispose();
    _descriptionDeController.dispose();
    _descriptionEnController.dispose();
    _descriptionZhController.dispose();
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
