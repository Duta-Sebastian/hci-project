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
    // Calculate if over goal and by how much
    final isOverGoal = nutritionData.caloriesLeft < 0;
    final caloriesOver = isOverGoal ? -nutritionData.caloriesLeft : 0;
    
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CustomPaint(
              painter: CaloriesPieChartPainter(
                consumedCalories: nutritionData.consumedCalories,
                totalCalories: nutritionData.totalCalories,
                caloriesLeft: nutritionData.caloriesLeft,
                caloriesOver: caloriesOver,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 14,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Calories left',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOverGoal ? 'Calories over goal' : 'Calories left',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
    
    final dailyGoal = nutritionData.totalCalories;
    final currentDayValue = dailyGoal > 0 ? nutritionData.consumedCalories / dailyGoal : 0.0;
    
    List<double> values = [0.95, 0.98, 0.85, 0.92, 1.35, 0.88, currentDayValue];
    
    final weeklyGoal = dailyGoal * 7;
    final totalConsumed = ((dailyGoal * 0.95) + (dailyGoal * 0.98) + (dailyGoal * 0.85) + 
                          (dailyGoal * 0.92) + (dailyGoal * 1.35) + (dailyGoal * 0.88) + 
                          nutritionData.consumedCalories).round();
    final averageDaily = (totalConsumed / 7).round();
    final percentage = weeklyGoal > 0 ? ((totalConsumed / weeklyGoal) * 100).round() : 0;
    
    const double baseBarHeight = 40.0;
    const double maxBarHeight = 50.0;
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 2,
                  width: 15,
                  color: Colors.green[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Goal: $dailyGoal kcal',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: baseBarHeight + 14,
                  child: Container(
                    height: 1,
                    color: Colors.green[600],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: labels.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    double value = values[index];
                    
                    Color barColor;
                    if (value > 1.0) {
                      barColor = Colors.red[300]!;
                    } else {
                      barColor = Colors.purple[300]!;
                    }
                    
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
                            width: 16,
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
                              fontSize: 9,
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
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average calories per day',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$averageDaily',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'weekly calories consumed',
                          style: TextStyle(
                            fontSize: 9,
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
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'of target reached',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                              values.indexOf(values.reduce((a, b) => a < b ? a : b)) == 6 ? 'Today' : 
                              labels[values.indexOf(values.reduce((a, b) => a < b ? a : b))],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'best day (${(dailyGoal * values.reduce((a, b) => a < b ? a : b)).round()} kcal)',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                              values.indexOf(values.reduce((a, b) => a > b ? a : b)) == 6 ? 'Today' : 
                              labels[values.indexOf(values.reduce((a, b) => a > b ? a : b))],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'worst day (${(dailyGoal * values.reduce((a, b) => a > b ? a : b)).round()} kcal)',
                              style: TextStyle(
                                fontSize: 8,
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
    final dailyGoal = nutritionData.totalCalories;
    final currentDayValue = dailyGoal > 0 ? nutritionData.consumedCalories / dailyGoal : 0.0;
    
    List<double> dailyValues = [
      0.8, 0.9, 1.1, 0.7, 1.3, 0.85, 0.95,
      1.0, 0.9, 0.8, 1.2, 0.75, 0.9, 1.05,
      0.85, 1.1, 0.95, 0.8, 1.4, 0.9, 0.85,
      1.0, 0.95, 0.8, 1.15, 0.9, 1.25, 0.85, currentDayValue
    ];
    
    final monthlyGoal = dailyGoal * 30;
    final sampleDaysTotal = (dailyGoal * (0.8 + 0.9 + 1.1 + 0.7 + 1.3 + 0.85 + 0.95 + 
                                         1.0 + 0.9 + 0.8 + 1.2 + 0.75 + 0.9 + 1.05 +
                                         0.85 + 1.1 + 0.95 + 0.8 + 1.4 + 0.9 + 0.85 +
                                         1.0 + 0.95 + 0.8 + 1.15 + 0.9 + 1.25 + 0.85)).round();
    final totalMonthlyConsumed = sampleDaysTotal + nutritionData.consumedCalories;
    final averageMonthly = (totalMonthlyConsumed / 30).round();
    final percentage = monthlyGoal > 0 ? ((totalMonthlyConsumed / monthlyGoal) * 100).round() : 0;
    
    final daysWithinGoal = dailyValues.where((v) => v >= 0.8 && v <= 1.0).length;
    final daysOverGoal = dailyValues.where((v) => v > 1.0).length;
    final daysUnderGoal = dailyValues.where((v) => v < 0.8).length;
    
    const double baseBarHeight = 50.0;
    const double maxBarHeight = 75.0;
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 2,
                  width: 15,
                  color: Colors.green[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Goal: $dailyGoal kcal',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Positioned(
                  left: 50,
                  right: 16,
                  bottom: baseBarHeight + 14,
                  child: Container(
                    height: 1,
                    color: Colors.green[600],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('3k', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                          Text('2k', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                          Text('1k', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                          Text('0', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: dailyValues.take(30).map((value) {
                                Color barColor;
                                if (value > 1.0) {
                                  barColor = Colors.red[300]!;
                                } else {
                                  barColor = Colors.purple[300]!;
                                }
                                
                                double barHeight = baseBarHeight * value;
                                if (barHeight > maxBarHeight) {
                                  barHeight = maxBarHeight;
                                }
                                
                                return Container(
                                  width: 4,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('5', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('10', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('15', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('20', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('25', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                              Text('30', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average calories per day',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$averageMonthly',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalMonthlyConsumed',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'total monthly calories consumed',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'of target reached',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$daysWithinGoal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'number of days\nwithin goal',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$daysOverGoal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'number of days\nover goal',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$daysUnderGoal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            Text(
                              'number of days\nunder goal',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CaloriesPieChartPainter extends CustomPainter {
  final int consumedCalories;
  final int totalCalories;
  final int caloriesLeft;
  final int caloriesOver;

  CaloriesPieChartPainter({
    required this.consumedCalories,
    required this.totalCalories,
    required this.caloriesLeft,
    required this.caloriesOver,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    
    if (totalCalories == 0) return;
    
    final consumedAngle = (consumedCalories / totalCalories) * 2 * 3.14159;
    final remainingAngle = (caloriesLeft / totalCalories) * 2 * 3.14159;
    
    // Determine colors based on calorie status
    if (caloriesLeft < 0) {
      // Over goal - always red when over any amount
      paint.color = Colors.red.shade400;
      
      // Draw full circle when over goal
      canvas.drawCircle(center, radius, paint);
    } else {
      // Under or at goal - use purple
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
  }

  @override
  bool shouldRepaint(CaloriesPieChartPainter oldDelegate) {
    return oldDelegate.consumedCalories != consumedCalories ||
           oldDelegate.totalCalories != totalCalories ||
           oldDelegate.caloriesLeft != caloriesLeft ||
           oldDelegate.caloriesOver != caloriesOver;
  }
}