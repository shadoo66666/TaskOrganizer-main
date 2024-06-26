import 'dart:math';

import 'package:flutter/material.dart';

class ProgressChartPainter extends CustomPainter {
  final double inProgress;
  final double done;
  final double toDo;

  ProgressChartPainter({
    required this.inProgress,
    required this.done,
    required this.toDo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total = inProgress + done + toDo;
    double startAngle = 0;
    double sweepAngleInProgress = 2 * pi * (inProgress / total);
    double sweepAngleDone = 2 * pi * (done / total);
    double sweepAngleToDo = 2 * pi * (toDo / total);

    Paint paintInProgress = Paint()..color = Color(0xFFE91E63);
    Paint paintDone = Paint()..color = Color(0xFF9C27B0);
    Paint paintToDo = Paint()..color = Color(0xFF673AB7);

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      startAngle,
      sweepAngleInProgress,
      true,
      paintInProgress,
    );

    startAngle += sweepAngleInProgress;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      startAngle,
      sweepAngleDone,
      true,
      paintDone,
    );

    startAngle += sweepAngleDone;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      startAngle,
      sweepAngleToDo,
      true,
      paintToDo,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}