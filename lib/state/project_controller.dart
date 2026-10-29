import 'dart:async';
import 'package:flutter/material.dart';
import '../ffi/tracktion_bridge.dart';
import '../models/channel.dart';
import '../models/pattern.dart';

class ProjectController extends ChangeNotifier {
  late TracktionEngine _engine;
  late Project _project;
  Transport? _transport;
  Timer? _playbackTimer;

  List<Pattern> patterns = [];
  String activePatternId = '';
  List<Channel> channels = [];

  int currentStep = -1;
  int stepCount = 16;
  double bpm = 140;
  bool isPlaying = false;

  Future<void> init() async {
    try {
      _engine = TracktionEngine.create();
      _project = _engine.createProject('demo_project.edit');
      _transport = _project.transport;
      _transport?.bpm = bpm;

      addPattern('Pattern 1', Colors.orange);

      final trackNames = ['Kick', 'Clap', 'Hat', 'Snare', '808 Synth', 'Lead Synth'];
      final defaultNotes = [36, 38, 42, 40, 48, 60];

      for (int i = 0; i < trackNames.length; i++) {
        final track = _project.addInstrumentTrack(trackNames[i]);
        final clip = track.createStepClip('Steps', 0.0, 4.0);
        
        final ch = Channel(
          index: i,
          name: trackNames[i],
          color: Colors.primaries[i % Colors.primaries.length],
          stepClip: clip,
          midiNote: defaultNotes[i % defaultNotes.length],
        );
        channels.add(ch);
      }
    } catch (e) {
      debugPrint('Engine Init Warning: $e');
    }
    notifyListeners();
  }

  void addPattern([String? name, Color? color]) {
    final p = Pattern(
      id: 'pat_${patterns.length + 1}',
      name: name ?? 'Pattern ${patterns.length + 1}',
      color: color ?? Colors.orange,
    );
    patterns.add(p);
    activePatternId = p.id;
    notifyListeners();
  }

  void selectPattern(String id) {
    activePatternId = id;
    notifyListeners();
  }

  void toggleStep(int channelIdx, int step, double velocity) {
    if (channelIdx >= 0 && channelIdx < channels.length) {
      channels[channelIdx].toggleStep(step, velocity);
      notifyListeners();
    }
  }

  void setBpm(double newBpm) {
    bpm = newBpm;
    _transport?.bpm = bpm;
    notifyListeners();
  }

  void play() {
    _transport?.play();
    isPlaying = true;

    // Timer sync UI dengan C++ Engine Transport Position
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!isPlaying) return;
      
      // Ambil posisi beat saat ini dan hitung step-nya
      double currentBeat = 0.0; 
      int calculatedStep = ((currentBeat * 4) % stepCount).toInt();

      if (calculatedStep != currentStep) {
        currentStep = calculatedStep;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void stop() {
    _transport?.stop();
    isPlaying = false;
    currentStep = -1;
    _playbackTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _engine.dispose();
    super.dispose();
  }
}