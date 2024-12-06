import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';

class HolidayPage extends StatelessWidget {
  final String name;
  HolidayPage({super.key, required this.name});

  final string2Icon = <String, IconData>{
    'celebration': Icons.celebration_outlined,
    'construction': Icons.construction_outlined,
    'handshake': Icons.handshake_outlined,
    'park': Icons.park_outlined,
    'forest': Icons.forest_outlined,
    'church': Icons.church_outlined,
    'cruelty_free': Icons.cruelty_free_outlined,
    'egg': Icons.egg_outlined,
    'cloud_upload': Icons.cloud_upload_outlined,
    'lightbulb': Icons.lightbulb_outline_rounded,
    'local_fire_department': Icons.local_fire_department_outlined,
    'star': Icons.star_border_outlined,
    'face_3': Icons.face_3_outlined,
    'sentiment_very_dissatisfied': Icons.sentiment_very_dissatisfied_outlined,
    'mood': Icons.mood_outlined,
    'cloud_done': Icons.cloud_done_outlined,
    'child_care': Icons.child_care_outlined,
    'description': Icons.description_outlined,
    'accessibility': Icons.accessibility_outlined,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorScheme.antiFlash,
      appBar: AppBar(
        backgroundColor: AppColorScheme.lapisLazuli,
        elevation: 5,
        shadowColor: AppColorScheme.indigo,
        surfaceTintColor: Colors.transparent,
      ),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColorScheme.ownWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                string2Icon[name.split(';')[1]],
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                name.split(';')[0],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColorScheme.ownBlack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
