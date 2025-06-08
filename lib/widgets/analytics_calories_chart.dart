import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesChart extends StatelessWidget {
  final NutritionData nutritionData;
  final int periodIndex;

  const AnalyticsCaloriesChart({
    super.key,
    required this.nutritionData,
    required this.periodIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (periodIndex == 0) {
      return _buildPieChart();
    } else if (periodIndex == 1) {
      return _buildWeekAnalytics();
    } else {
      return _buildBarChart();
    }
  }

  Widget _buildPieChart() {
    return Container(
      height: 180, // Reduced from 220
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140, // Reduced from 180
            height: 140,
            child: CustomPaint(
              painter: CaloriesPieChartPainter(
                consumedCalories: nutritionData.consumedCalories,
                totalCalories: nutritionData.totalCalories,
                caloriesLeft: nutritionData.caloriesLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${nutritionData.caloriesLeft}',
                style: const TextStyle(
                  fontSize: 28, // Reduced from 32
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 14, // Reduced from 16
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Calories left',
                    style: TextStyle(
                      fontSize: 11, // Reduced from 12
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekAnalytics() {
    List<String> labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<double> values = [0.95, 0.98, 0.85, 0.92, 1.35, 0.88, 1.1];
    
    final dailyGoal = nutritionData.totalCalories;
    final weeklyGoal = dailyGoal * 7;
    final totalConsumed = (weeklyGoal * 1.08).toInt();
    final averageDaily = (totalConsumed / 7).round();
    final percentage = ((totalConsumed / weeklyGoal) * 100).round();
    
    const double baseBarHeight = 50.0; // Height for 100% (goal)
    const double maxBarHeight = 75.0;  // Maximum bar height (150% of goal)
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 300), // Add height constraint
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Goal line indicator
          Container(
            height: 25, // Reduced from 30
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 2,
                  width: 15, // Reduced from 20
                  color: Colors.green[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Goal: $dailyGoal kcal',
                  style: TextStyle(
                    fontSize: 11, // Reduced from 12
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Bar chart with proper goal line overlay
          Container(
            height: 80, // Reduced from 120
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // Goal line overlay
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: baseBarHeight + 14, // Position at 100% goal level + space for labels
                  child: Container(
                    height: 1,
                    color: Colors.green[600],
                  ),
                ),
                
                // Bars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: labels.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    double value = values[index];
                    
                    Color barColor;
                    if (value >= 0.8 && value <= 1.0) {
                      barColor = Colors.green[400]!;
                    } else if (value > 1.0) {
                      barColor = Colors.red[400]!;
                    } else {
                      barColor = Colors.orange[400]!;
                    }
                    
                    // Calculate bar height: goal (1.0) = baseBarHeight, cap at maxBarHeight
                    double barHeight = baseBarHeight * value;
                    if (barHeight > maxBarHeight) {
                      barHeight = maxBarHeight;
                    }
                    
                    return Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16, // Reduced from 20
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: barColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 9, // Reduced from 10
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12), // Reduced from 16
          
          // Compact Statistics Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12), // Reduced from 16
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Average calories per day
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average calories per day',
                      style: TextStyle(
                        fontSize: 11, // Reduced from 12
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$averageDaily',
                      style: const TextStyle(
                        fontSize: 14, // Reduced from 16
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8), // Reduced from 12
                
                // Total consumed and percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalConsumed',
                          style: const TextStyle(
                            fontSize: 18, // Reduced from 20
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'weekly calories consumed',
                          style: TextStyle(
                            fontSize: 9, // Reduced from 10
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.green,
                          size: 14, // Reduced from 16
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 18, // Reduced from 20
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'of target reached',
                              style: TextStyle(
                                fontSize: 9, // Reduced from 10
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8), // Reduced from 12
                
                // Best and worst days
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8), // Reduced from 10
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tuesday',
                              style: TextStyle(
                                fontSize: 11, // Reduced from 12
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'the best day of calories',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 9
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'consumed (${(dailyGoal * 0.98).round()} kcal)',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 9
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced from 8
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8), // Reduced from 10
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Friday',
                              style: TextStyle(
                                fontSize: 11, // Reduced from 12
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'the worst day of calories',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 9
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'consumed (${(dailyGoal * 1.35).round()} kcal)',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 9
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    List<String> labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    List<double> values = [0.88, 0.92, 0.85, 0.78];

    return Container(
      height: 160, // Reduced from 200
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: labels.asMap().entries.map((entry) {
          int index = entry.key;
          String label = entry.value;
          double value = values[index];
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20, // Reduced from 24
                height: 100 * value, // Reduced from 140
                decoration: BoxDecoration(
                  color: Colors.purple[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10, // Reduced from 11
                  color: Colors.grey[600],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class CaloriesPieChartPainter extends CustomPainter {
  final int consumedCalories;
  final int totalCalories;
  final int caloriesLeft;

  CaloriesPieChartPainter({
    required this.consumedCalories,
    required this.totalCalories,
    required this.caloriesLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    
    if (totalCalories == 0) return;
    
    final consumedAngle = (consumedCalories / totalCalories) * 2 * 3.14159;
    final remainingAngle = (caloriesLeft / totalCalories) * 2 * 3.14159;
    
    paint.color = Colors.purple.shade300;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      consumedAngle,
      true,
      paint,
    );
    
    paint.color = Colors.purple.shade50;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57 + consumedAngle,
      remainingAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CaloriesPieChartPainter oldDelegate) {
    return oldDelegate.consumedCalories != consumedCalories ||
           oldDelegate.totalCalories != totalCalories ||
           oldDelegate.caloriesLeft != caloriesLeft;
  }
}