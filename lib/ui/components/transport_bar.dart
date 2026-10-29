import 'package:flutter/material.dart';
import '../../state/project_controller.dart';

class TransportBar extends StatelessWidget {
  final ProjectController controller;
  const TransportBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Container(
        height: 52,
        color: const Color(0xFF202020),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.green, size: 28),
              onPressed: controller.isPlaying ? controller.stop : controller.play,
            ),
            IconButton(
              icon: const Icon(Icons.stop, color: Colors.red, size: 24),
              onPressed: controller.stop,
            ),
            const SizedBox(width: 16),
            const Text('BPM', style: TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(width: 6),
            SizedBox(
              width: 50,
              child: TextField(
                controller: TextEditingController(text: controller.bpm.round().toString()),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                onSubmitted: (v) => controller.setBpm(double.tryParse(v) ?? 140),
              ),
            ),
            const Spacer(),
            Text('Step: ${controller.currentStep + 1}',
                style: const TextStyle(color: Colors.orange, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
