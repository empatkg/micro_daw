import 'package:flutter/material.dart';
import '../../state/project_controller.dart';

class PianoRollView extends StatelessWidget {
  final ProjectController controller;
  const PianoRollView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      child: const Center(child: Text('Piano Roll Canvas View', style: TextStyle(color: Colors.grey, fontSize: 12))),
    );
  }
}
