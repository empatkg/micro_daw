import 'package:flutter/material.dart';
import '../../state/project_controller.dart';

class MixerView extends StatelessWidget {
  final ProjectController controller;
  const MixerView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Mixer Console View', style: TextStyle(color: Colors.grey, fontSize: 12)));
  }
}
