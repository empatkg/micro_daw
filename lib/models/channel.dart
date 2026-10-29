import 'package:flutter/material.dart';
import '../ffi/tracktion_bridge.dart';

class Channel {
  final int index;
  final String name;
  final Color color;
  final StepClip stepClip;
  final List<double> steps;
  int stepCount;
  double volume;
  double pan;
  int midiNote;
  bool muted;

  Channel({
    required this.index,
    required this.name,
    required this.color,
    required this.stepClip,
    this.stepCount = 16,
    this.volume = 0.8,
    this.pan = 0.0,
    this.midiNote = 60,
    this.muted = false,
  }) : steps = List<double>.filled(64, 0.0);

  void toggleStep(int step, double velocity) {
    if (step < 0 || step >= stepCount) return;
    steps[step] = velocity < 0.01 ? 0.0 : velocity.clamp(0.0, 1.0);
    stepClip.setCell(index, step, steps[step]);
    stepClip.setChannelNote(index, midiNote);
  }

  void setVolume(double v) => volume = v.clamp(0.0, 1.0);
  void setPan(double p) => pan = p.clamp(-1.0, 1.0);
  void toggleMute() => muted = !muted;
}
