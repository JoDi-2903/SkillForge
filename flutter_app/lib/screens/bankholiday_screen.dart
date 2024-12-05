import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';

class HolidayPage extends StatelessWidget {
  final String name;
  const HolidayPage({super.key, required this.name});

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
                Icons.check_circle,
                color: Colors.green,
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
