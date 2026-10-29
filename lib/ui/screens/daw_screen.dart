import 'package:flutter/material.dart';
import '../../state/project_controller.dart';
import '../components/transport_bar.dart';
import '../components/pattern_matrix.dart';
import '../editors/channel_rack.dart';
import '../editors/piano_roll.dart';
import '../editors/playlist.dart';
import '../editors/mixer.dart';

enum DawView { channelRack, pianoRoll, playlist, mixer }

class DawScreen extends StatefulWidget {
  final ProjectController controller;
  const DawScreen({required this.controller, super.key});

  @override
  State<DawScreen> createState() => _DawScreenState();
}

class _DawScreenState extends State<DawScreen> {
  DawView currentView = DawView.channelRack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TransportBar(controller: widget.controller),
            PatternMatrix(controller: widget.controller),
            Expanded(child: _buildBody()),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (currentView) {
      case DawView.channelRack: return ChannelRack(controller: widget.controller);
      case DawView.pianoRoll: return PianoRollView(controller: widget.controller);
      case DawView.playlist: return PlaylistView(controller: widget.controller);
      case DawView.mixer: return MixerView(controller: widget.controller);
    }
  }

  Widget _buildNavBar() {
    return Container(
      height: 48,
      color: const Color(0xFF222222),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem('Rack', Icons.grid_on, DawView.channelRack),
          _navItem('Piano', Icons.piano, DawView.pianoRoll),
          _navItem('Playlist', Icons.view_timeline, DawView.playlist),
          _navItem('Mixer', Icons.tune, DawView.mixer),
        ],
      ),
    );
  }

  Widget _navItem(String label, IconData icon, DawView view) {
    final active = currentView == view;
    return InkWell(
      onTap: () => setState(() => currentView = view),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? Colors.orange : Colors.grey, size: 18),
          Text(label, style: TextStyle(color: active ? Colors.orange : Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }
}
