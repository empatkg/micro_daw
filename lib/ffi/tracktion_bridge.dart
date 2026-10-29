import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'bindings.dart';

class TracktionEngine {
  final TE_Engine _engine;
  TracktionEngine._(this._engine);

  static TracktionEngine create({String appName = 'MicroDAW', String logsPath = ''}) {
    final namePtr = appName.toNativeUtf8();
    final logsPtr = logsPath.toNativeUtf8();
    final eng = teEngineCreate(namePtr, logsPtr);
    calloc.free(namePtr);
    calloc.free(logsPtr);
    return TracktionEngine._(eng);
  }

  Project createProject(String filePath) {
    final pathPtr = filePath.toNativeUtf8();
    final edit = teEditCreateEmpty(_engine, pathPtr);
    calloc.free(pathPtr);
    return Project._(edit);
  }

  void dispose() => teEngineDestroy(_engine);
}

class Project {
  final TE_Edit _edit;
  Project._(this._edit);

  final List<Track> tracks = [];

  Transport get transport => Transport._(_edit);

  Track addInstrumentTrack(String name) {
    final namePtr = name.toNativeUtf8();
    final t = teTrackInsertInstrumentTrack(_edit, namePtr);
    calloc.free(namePtr);
    final track = Track._(t, this);
    tracks.add(track);
    return track;
  }

  void save() => teEditSave(_edit);
}

class Transport {
  final TE_Edit _edit;
  Transport._(this._edit);

  void play({bool record = false}) => teTransportPlay(_edit, record ? 1 : 0);
  void stop() => teTransportStop(_edit);
  set bpm(double value) => teTransportSetBpm(_edit, value);
}

class Track {
  final TE_Track _track;
  final Project project;
  Track._(this._track, this.project);

  StepClip createStepClip(String name, double startBeat, double lengthBeats) {
    final namePtr = name.toNativeUtf8();
    final clip = teStepClipCreate(_track, namePtr, startBeat, lengthBeats);
    calloc.free(namePtr);
    return StepClip._(clip);
  }

  MidiClip createMidiClip(String name, double startBeat, double lengthBeats) {
    final namePtr = name.toNativeUtf8();
    final clip = teMidiClipCreate(_track, namePtr, startBeat, lengthBeats);
    calloc.free(namePtr);
    return MidiClip._(clip);
  }
}

class StepClip {
  final TE_Clip _clip;
  StepClip._(this._clip);

  void setCell(int channel, int step, double velocity) {
    teStepClipSetCell(_clip, channel, step, velocity);
  }

  void setChannelNote(int channel, int midiNote) {
    teStepClipSetChannelNote(_clip, channel, midiNote);
  }
}

class MidiClip {
  final TE_Clip _clip;
  MidiClip._(this._clip);

  void addNote(int pitch, double startBeat, double lengthBeats,
      {double velocity = 0.8, bool slide = false}) {
    teMidiClipAddNote(_clip, pitch, startBeat, lengthBeats, velocity, slide ? 1 : 0);
  }
}
