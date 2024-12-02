import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import '../utils/buttons.dart';
import 'package:skill_forge/utils/interfaces.dart';

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
        title: Text(name),
        centerTitle: true,
      ),
    );
  }
}
