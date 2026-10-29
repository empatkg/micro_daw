import 'package:flutter/material.dart';
import '../ffi/tracktion_bridge.dart';
import '../models/channel.dart';
import '../models/pattern.dart';
import '../models/note.dart';

class ProjectController extends ChangeNotifier {
  late TracktionEngine _engine;
  late Project _project;
  Transport? _transport;

  List<Pattern> patterns = [];
  String activePatternId = '';
  List<Channel> channels = [];
  
  int currentStep = -1;
  int stepCount = 16;
  double bpm = 140;
  bool isPlaying = false;
  int activeChannelIndex = 0;

  Future<void> init() async {
    try {
      _engine = TracktionEngine.create();
      _project = _engine.createProject('demo_project.edit');
      _transport = _project.transport;
      _transport?.bpm = bpm;

      addPattern('Pattern 1', Colors.orange);

      final trackNames = ['Kick', 'Clap', 'Hat', 'Snare', 'OpenHat', '808', 'Synth', 'FX'];
      for (int i = 0; i < trackNames.length; i++) {
        final track = _project.addInstrumentTrack(trackNames[i]);
        final clip = track.createStepClip('Steps', 0.0, 4.0);
        channels.add(Channel(
          index: i,
          name: trackNames[i],
          color: Colors.primaries[i % Colors.primaries.length],
          stepClip: clip,
        ));
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

  void duplicatePattern(String id) {
    final orig = patterns.firstWhere((p) => p.id == id, orElse: () => patterns.first);
    addPattern('${orig.name} Copy', orig.color);
  }

  void deletePattern(String id) {
    if (patterns.length > 1) {
      patterns.removeWhere((p) => p.id == id);
      activePatternId = patterns.first.id;
      notifyListeners();
    }
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
    notifyListeners();
  }

  void stop() {
    _transport?.stop();
    isPlaying = false;
    currentStep = -1;
    notifyListeners();
  }
}
