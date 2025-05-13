import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalorieProgressCircle extends StatelessWidget {
  final int caloriesLeft;
  final int totalCalories;
  final int consumedCalories;

  const CalorieProgressCircle({
    super.key,
    required this.caloriesLeft,
    required this.totalCalories,
    required this.consumedCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: CalorieProgressPainter(
                  progressPercent: _calculateProgress(),
                  progressColor: Colors.purple.shade300,
                  totalCalories: totalCalories,
                ),
              ),
            ),
            
            Positioned(
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$caloriesLeft',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Calories left',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress() {
    return consumedCalories / totalCalories;
  }
}

class CalorieProgressPainter extends CustomPainter {
  final double progressPercent;
  final Color progressColor;
  final int totalCalories;

  CalorieProgressPainter({
    required this.progressPercent,
    required this.progressColor,
    required this.totalCalories,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    final basePaint = Paint()
      ..color = Colors.purple.shade50
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      rect,
      -math.pi,
      math.pi,
      false,
      basePaint,
    );
    
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      rect,
      -math.pi,
      math.pi * progressPercent,
      false,
      progressPaint,
    );
    
    final startPos = Offset(
      center.dx - radius,
      center.dy
    );
    
    final endPos = Offset(
      center.dx + radius,
      center.dy
    );
    
    final textStyle = TextStyle(
      color: Colors.grey.shade700,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    
    final startTextSpan = TextSpan(
      text: '0',
      style: textStyle,
    );
    final startTextPainter = TextPainter(
      text: startTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    startTextPainter.layout();
    startTextPainter.paint(
      canvas, 
      Offset(startPos.dx - startTextPainter.width / 2, startPos.dy + 15)
    );
    
    final endTextSpan = TextSpan(
      text: '$totalCalories',
      style: textStyle,
    );
    final endTextPainter = TextPainter(
      text: endTextSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    endTextPainter.layout();
    endTextPainter.paint(
      canvas, 
      Offset(endPos.dx - endTextPainter.width / 2, endPos.dy + 15)
    );
    
    // Only draw the needle when the size is valid (not during initial layout)
    if (size.width > 0 && size.height > 0) {
      final needlePaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
        
      final needleAngle = -math.pi + math.pi * progressPercent;
      
      final endX = center.dx + radius * 0.8 * math.cos(needleAngle);
      final endY = center.dy + radius * 0.8 * math.sin(needleAngle);
      
      canvas.drawLine(center, Offset(endX, endY), needlePaint);
      
      final knobPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, 5.0, knobPaint);
    }
  }

  @override
  bool shouldRepaint(CalorieProgressPainter oldDelegate) {
    // Only repaint when the actual values change
    return oldDelegate.progressPercent != progressPercent ||
           oldDelegate.progressColor != progressColor ||
           oldDelegate.totalCalories != totalCalories;
  }
}