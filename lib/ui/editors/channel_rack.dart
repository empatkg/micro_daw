import 'package:flutter/material.dart';
import '../../state/project_controller.dart';
import '../components/touch_knob.dart';

class ChannelRack extends StatelessWidget {
  final ProjectController controller;
  const ChannelRack({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => ListView.builder(
        itemCount: controller.channels.length,
        itemBuilder: (context, idx) {
          final ch = controller.channels[idx];
          return Container(
            height: 48,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[850]!))),
            child: Row(
              children: [
                Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(border: Border(left: BorderSide(color: ch.color, width: 3))),
                  child: Row(
                    children: [
                      Expanded(child: Text(ch.name, style: const TextStyle(fontSize: 10, color: Colors.white), overflow: TextOverflow.ellipsis)),
                      TouchKnob(value: ch.volume, onChanged: (v) => controller.channels[idx].setVolume(v)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: List.generate(16, (step) {
                      final isActive = ch.steps[step] > 0;
                      final isBeat = step % 4 == 0;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleStep(idx, step, isActive ? 0.0 : 0.8),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isActive ? ch.color : (isBeat ? Colors.grey[800] : Colors.grey[900]),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
