import 'dart:math' as math;
import 'package:flutter/material.dart';

class TouchKnob extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double size;

  const TouchKnob({required this.value, required this.onChanged, this.size = 28, super.key});

  @override
  State<TouchKnob> createState() => _TouchKnobState();
}

class _TouchKnobState extends State<TouchKnob> {
  double _startY = 0;
  double _startValue = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (d) {
        _startY = d.globalPosition.dy;
        _startValue = widget.value;
      },
      onVerticalDragUpdate: (d) {
        final delta = (_startY - d.globalPosition.dy) / 150;
        widget.onChanged((_startValue + delta).clamp(0.0, 1.0));
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _KnobPainter(value: widget.value)),
      ),
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double value;
  _KnobPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 2;
    canvas.drawCircle(c, r, Paint()..color = Colors.grey[700]!..style = PaintingStyle.stroke..strokeWidth = 2);

    final start = -math.pi * 0.75;
    final sweep = math.pi * 1.5 * value.clamp(0.0, 1.0);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, sweep, false, Paint()..color = Colors.orange..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _KnobPainter old) => old.value != value;
}
