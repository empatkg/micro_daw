import 'package:flutter/material.dart';
import 'note.dart';

class Pattern {
  final String id;
  String name;
  Color color;
  double lengthBeats;
  List<Note> notes;

  Pattern({
    required this.id,
    required this.name,
    required this.color,
    this.lengthBeats = 4.0,
    List<Note>? notes,
  }) : notes = notes ?? [];

  bool get isEmpty => notes.isEmpty;
  int get noteCount => notes.length;
}
