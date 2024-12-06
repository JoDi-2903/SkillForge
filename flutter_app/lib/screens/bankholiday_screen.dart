import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/utils/languages.dart';

class HolidayPage extends StatelessWidget {
  final String name;
  HolidayPage({super.key, required this.name});

  final string2Icon = <String, IconData>{
    AppStrings.newYear: Icons.celebration_outlined,
    AppStrings.firstMay: Icons.construction_outlined,
    AppStrings.germanUnity: Icons.handshake_outlined,
    AppStrings.christmas1: Icons.park_outlined,
    AppStrings.christmas2: Icons.forest_outlined,
    AppStrings.carFriday: Icons.church_outlined,
    AppStrings.easterSunday: Icons.cruelty_free_outlined,
    AppStrings.easterMonday: Icons.egg_outlined,
    AppStrings.christHeavenDrive: Icons.cloud_upload_outlined,
    AppStrings.whitSunday: Icons.lightbulb_outline_rounded,
    AppStrings.whitMonday: Icons.local_fire_department_outlined,
    AppStrings.epiphany: Icons.star_border_outlined,
    AppStrings.intlWomen: Icons.face_3_outlined,
    AppStrings.happyCadaver: Icons.sentiment_very_dissatisfied_outlined,
    AppStrings.peaceParty: Icons.mood_outlined,
    AppStrings.mariaHeavenDrive: Icons.cloud_done_outlined,
    AppStrings.worldChildDay: Icons.child_care_outlined,
    AppStrings.reformationDay: Icons.description_outlined,
    AppStrings.allSaints: Icons.accessibility_outlined,
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
                string2Icon[name],
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                name,
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
