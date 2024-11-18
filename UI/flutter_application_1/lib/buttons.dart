
import 'dart:ui';
import 'package:flutter/material.dart';
import 'main.dart';

class ButtonBack extends StatefulWidget{
  final Function() backFunction;
  const ButtonBack({super.key, required this.backFunction()});

  @override
  State<ButtonBack> createState() => _ButtonBackState();
}

class _ButtonBackState extends State<ButtonBack>{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.calendar_month),
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