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
    final bool isOverflow = consumedCalories > totalCalories;
    final int overflowAmount = isOverflow ? consumedCalories - totalCalories : 0;
    
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
                  progressColor: isOverflow ? Colors.red.shade400 : Colors.purple.shade300,
                  totalCalories: totalCalories,
                  isOverflow: isOverflow,
                ),
              ),
            ),
            
            Positioned(
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isOverflow) ...[
                    // Overflow display
                    Text(
                      '+$overflowAmount',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 16,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Over goal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Normal display
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
                ],
              ),
            ),
            
            // Add a subtle overflow indicator ring
            if (isOverflow)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress() {
    if (consumedCalories > totalCalories) {
      // For overflow, show a complete circle plus a bit extra
      return 1.0;
    }
    return consumedCalories / totalCalories;
  }
}

class CalorieProgressPainter extends CustomPainter {
  final double progressPercent;
  final Color progressColor;
  final int totalCalories;
  final bool isOverflow;

  CalorieProgressPainter({
    required this.progressPercent,
    required this.progressColor,
    required this.totalCalories,
    required this.isOverflow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Base arc
    final basePaint = Paint()
      ..color = isOverflow ? Colors.red.shade50 : Colors.purple.shade50
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
    
    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;
    
    if (isOverflow) {
      // Draw full flat arc for overflow (no extra indicator)
      canvas.drawArc(
        rect,
        -math.pi,
        math.pi,
        false,
        progressPaint,
      );
    } else {
      canvas.drawArc(
        rect,
        -math.pi,
        math.pi * progressPercent,
        false,
        progressPaint,
      );
    }
    
    // Labels
    final startPos = Offset(center.dx - radius, center.dy);
    final endPos = Offset(center.dx + radius, center.dy);
    
    final textStyle = TextStyle(
      color: isOverflow ? Colors.red.shade600 : Colors.grey.shade700,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    
    // Start label
    final startTextSpan = TextSpan(text: '0', style: textStyle);
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
    
    // End label
    final endTextSpan = TextSpan(text: '$totalCalories', style: textStyle);
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
    
    // Needle (only when size is valid)
    if (size.width > 0 && size.height > 0) {
      final needlePaint = Paint()
        ..color = isOverflow ? Colors.red.shade700 : Colors.black
        ..strokeWidth = isOverflow ? 3.0 : 2.0
        ..style = PaintingStyle.stroke;
        
      final needleAngle = isOverflow 
          ? -math.pi + math.pi * 1.1 // Slightly past the end for overflow
          : -math.pi + math.pi * progressPercent;
      
      final endX = center.dx + radius * 0.8 * math.cos(needleAngle);
      final endY = center.dy + radius * 0.8 * math.sin(needleAngle);
      
      canvas.drawLine(center, Offset(endX, endY), needlePaint);
      
      // Needle knob
      final knobPaint = Paint()
        ..color = isOverflow ? Colors.red.shade700 : Colors.black
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, isOverflow ? 6.0 : 5.0, knobPaint);
    }
  }

  @override
  bool shouldRepaint(CalorieProgressPainter oldDelegate) {
    return oldDelegate.progressPercent != progressPercent ||
           oldDelegate.progressColor != progressColor ||
           oldDelegate.totalCalories != totalCalories ||
           oldDelegate.isOverflow != isOverflow;
  }
}