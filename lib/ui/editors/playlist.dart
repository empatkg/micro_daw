import 'package:flutter/material.dart';
import '../../state/project_controller.dart';

class PlaylistView extends StatelessWidget {
  final ProjectController controller;
  const PlaylistView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Playlist Arrangement View', style: TextStyle(color: Colors.grey, fontSize: 12)));
  }
}
