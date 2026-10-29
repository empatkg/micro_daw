import 'package:flutter/material.dart';

enum ClipType { pattern, audio, automation }

class PlaylistClip {
  final String id;
  final ClipType type;
  final int trackIndex;
  double startBeat;
  double lengthBeats;
  Color color;
  String name;

  PlaylistClip({
    String? id,
    required this.type,
    required this.trackIndex,
    required this.startBeat,
    required this.lengthBeats,
    required this.color,
    required this.name,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}
