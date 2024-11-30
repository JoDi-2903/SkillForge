import 'package:flutter/material.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:skill_forge/screens/month_screen.dart';
import 'package:skill_forge/utils/languages.dart';
import 'package:skill_forge/screens/login_screen.dart' as login;
import 'package:skill_forge/screens/admin_screen.dart' as admin;
import 'package:skill_forge/screens/week_screen.dart';

class ButtonBack extends StatefulWidget {
  final Function() backFunction;
  const ButtonBack({super.key, required this.backFunction()});

  @override
  State<ButtonBack> createState() => _ButtonBackState();
}

class _ButtonBackState extends State<ButtonBack> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            widget.backFunction();
          },
        ),
      ],
    );
  }
}

class ToggleSwitch extends StatefulWidget {
  final Function() notifyParent;
  const ToggleSwitch({super.key, required this.notifyParent});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  static bool light = false;

  @override
  void initState() {
    if (DateTime.now().hour > 18 || DateTime.now().hour <= 6) {
      light = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeTrackColor: AppColorScheme.indigo,
      inactiveTrackColor: AppColorScheme.slate,
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return const Color(0x66748590);
        },
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }
          return AppColorScheme.ownWhite;
        },
      ),
      thumbIcon: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Icon(Icons.light_mode, color: AppColorScheme.indigo);
          }
          return Icon(Icons.dark_mode, color: AppColorScheme.indigo);
        },
      ),
      onChanged: (bool value) {
        setState(() {
          light = value;
          AppColorScheme.setDarkmode(value);
          widget.notifyParent();
        });
      },
    );
  }
}

class MonthButton extends StatefulWidget {
  final Map<String, dynamic> filters;

  const MonthButton({super.key, required this.filters});

  @override
  State<MonthButton> createState() => _MonthButtonState();
}

class _MonthButtonState extends State<MonthButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_month_rounded),
      color: AppColorScheme.indigo,
      iconSize: 35,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonthPage(filters: widget.filters),
          ),
        );
      },
    );
  }
}

class LanguageButton extends StatefulWidget {
  final Function(String code) language;
  const LanguageButton({
    super.key,
    required this.language,
  });

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  final List<Language> list = <Language>[german, english, chinese];
  Language dropdownValue = english;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      value: dropdownValue,
      icon: const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
      dropdownColor: AppColorScheme.antiFlash,
      focusColor: AppColorScheme.antiFlash,
      underline: Container(
        height: 0,
        color: AppColorScheme.antiFlash,
      ),
      style: const TextStyle(
        fontSize: 24,
        fontFamily: 'Noto Color Emoji',
        fontFamilyFallback: ['Noto Color Emoji'],
      ),
      onChanged: (Language? lang) {
        setState(() {
          dropdownValue = lang!;
        });
        widget.language(dropdownValue.identifier);
      },
      items: list.map<DropdownMenuItem<Language>>((Language value) {
        return DropdownMenuItem<Language>(
          value: value,
          child: Text(value.icon),
        );
      }).toList(),
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const login.LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}

class AdminButton extends StatefulWidget {
  const AdminButton({super.key});

  @override
  State<AdminButton> createState() => _AdminButtonState();
}

class _AdminButtonState extends State<AdminButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.library_add),
          color: AppColorScheme.indigo,
          iconSize: 35,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const admin.AdminEventScreen()),
            );
          },
        ),
      ],
    );
  }
}

class WeekButton extends StatefulWidget {
  final Map<String, dynamic> filters;

  const WeekButton({super.key, required this.filters});

  @override
  State<WeekButton> createState() => _WeekButtonState();
}

class _WeekButtonState extends State<WeekButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_view_week_rounded),
      color: AppColorScheme.indigo,
      iconSize: 35,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeekPage(filters: widget.filters),
          ),
        );
      },
    );
  }
}
