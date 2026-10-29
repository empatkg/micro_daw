class Note {
  String id;
  int pitch;
  double startBeat;
  double lengthBeats;
  double velocity;
  double pan;
  bool slide;
  double finePitch;

  Note({
    String? id,
    required this.pitch,
    required this.startBeat,
    required this.lengthBeats,
    this.velocity = 0.8,
    this.pan = 0.0,
    this.slide = false,
    this.finePitch = 0.0,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}
