import 'package:flutter/material.dart';
import '../../state/project_controller.dart';

class PatternMatrix extends StatelessWidget {
  final ProjectController controller;
  const PatternMatrix({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Container(
        height: 64,
        color: const Color(0xFF2D2D2D),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: controller.patterns.length + 1,
          itemBuilder: (context, i) {
            if (i == controller.patterns.length) {
              return InkWell(
                onTap: () => controller.addPattern(),
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              );
            }
            final p = controller.patterns[i];
            final active = p.id == controller.activePatternId;
            return GestureDetector(
              onTap: () => controller.selectPattern(p.id),
              child: Container(
                width: 76,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: active ? p.color : p.color.withOpacity(0.2),
                  border: Border.all(color: active ? Colors.white : p.color, width: active ? 2 : 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(p.name, style: TextStyle(color: active ? Colors.white : p.color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
