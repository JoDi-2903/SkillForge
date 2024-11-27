import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/screens/login_screen.dart' as login;

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic> initialFilters;

  const FilterDialog({super.key, required this.initialFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool _filterByUser = false;
  List<String> _selectedEventTypes = [];
  List<String> _selectedSubjectAreas = [];

  final List<String> _eventTypes = [
    'Workshop',
    'Seminar',
    'Lecture',
    'Further training',
    'Other',
  ];

  final List<String> _subjectAreas = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Mechatronics',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Load initial filters if any
    _filterByUser = widget.initialFilters['user_id'] != null;
    _selectedEventTypes =
        List<String>.from(widget.initialFilters['event_type'] ?? []);
    _selectedSubjectAreas =
        List<String>.from(widget.initialFilters['subject_area'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final bool isUserLoggedIn = login.UserState().userId != null;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          color: AppColorScheme.ownWhite,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.filterOptions,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColorScheme.indigo,
                ),
              ),
              const SizedBox(height: 16),
              // User ID Filter
              CheckboxListTile(
                title: Text(AppStrings.filterByUser),
                value: _filterByUser,
                onChanged: isUserLoggedIn
                    ? (value) {
                        setState(() {
                          _filterByUser = value!;
                        });
                      }
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (!isUserLoggedIn)
                Text(
                  AppStrings.loginToFilter,
                  style: TextStyle(color: AppColorScheme.battleShip),
                ),
              const SizedBox(height: 16),
              // Event Type Filter
              ExpansionTile(
                title: Text(AppStrings.eventType),
                initiallyExpanded: _selectedEventTypes.isNotEmpty,
                children: _eventTypes.map((type) {
                  return CheckboxListTile(
                    title: Text(type),
                    value: _selectedEventTypes.contains(type),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedEventTypes.add(type);
                        } else {
                          _selectedEventTypes.remove(type);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Subject Area Filter
              ExpansionTile(
                title: Text(AppStrings.subjectArea),
                initiallyExpanded: _selectedSubjectAreas.isNotEmpty,
                children: _subjectAreas.map((area) {
                  return CheckboxListTile(
                    title: Text(area),
                    value: _selectedSubjectAreas.contains(area),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedSubjectAreas.add(area);
                        } else {
                          _selectedSubjectAreas.remove(area);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Clear filters
                      setState(() {
                        _filterByUser = false;
                        _selectedEventTypes.clear();
                        _selectedSubjectAreas.clear();
                      });
                      // Apply cleared filters
                      Navigator.pop(context, {
                        'user_id': _filterByUser
                            ? login.UserState().userId.toString()
                            : null,
                        'event_type': _selectedEventTypes,
                        'subject_area': _selectedSubjectAreas,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorScheme.battleShip,
                    ),
                    child: Text(AppStrings.clearFilters),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      Navigator.pop(context, {
                        'user_id': _filterByUser
                            ? login.UserState().userId.toString()
                            : null,
                        'event_type': _selectedEventTypes,
                        'subject_area': _selectedSubjectAreas,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorScheme.indigo,
                    ),
                    child: Text(AppStrings.applyFilters),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
