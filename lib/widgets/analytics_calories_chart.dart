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
    
    const double baseBarHeight = 40.0; // Height for 100% (goal)
    const double maxBarHeight = 50.0;  // Maximum bar height to prevent overflow
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Goal line indicator
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
          
          // Bar chart with proper goal line overlay
          Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // Goal line overlay
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: baseBarHeight + 14, // Position at 100% goal level
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
                    if (value > 1.0) {
                      barColor = Colors.red[300]!; // Light red when over goal
                    } else {
                      barColor = Colors.purple[300]!; // Purple for normal/under goal
                    }
                    
                    // Calculate bar height: goal (1.0) = baseBarHeight, cap at maxBarHeight
                    double barHeight = baseBarHeight * value;
                    if (barHeight > maxBarHeight) {
                      barHeight = maxBarHeight; // Strict cap to prevent overflow
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
          
          // Compact Statistics Card
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
                // Average calories per day
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
                
                // Best and worst days
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
                              'Tuesday',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'best day (${(dailyGoal * 0.98).round()} kcal)',
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
                              'Friday',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            Text(
                              'worst day (${(dailyGoal * 1.35).round()} kcal)',
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
    // Monthly data
    final totalMonthlyConsumed = 71200; // From Figma
    final averageMonthly = 2440; // From Figma
    final percentage = 103; // From Figma
    final dailyGoal = nutritionData.totalCalories;
    
    // Days breakdown from Figma
    final daysWithinGoal = 8;
    final daysOverGoal = 14;
    final daysUnderGoal = 9;
    
    // Sample daily data for the histogram (30 days) - as percentages of daily goal
    List<double> dailyValues = [
      0.8, 0.9, 1.1, 0.7, 1.3, 0.85, 0.95, // Week 1
      1.0, 0.9, 0.8, 1.2, 0.75, 0.9, 1.05, // Week 2  
      0.85, 1.1, 0.95, 0.8, 1.4, 0.9, 0.85, // Week 3
      1.0, 0.95, 0.8, 1.15, 0.9, 1.25, 0.85, 1.0, 0.95 // Week 4+
    ];
    
    const double baseBarHeight = 50.0; // Height for 100% (goal)
    const double maxBarHeight = 75.0;  // Maximum bar height (150% of goal)
    
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          
          // Goal line indicator (like week view)
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
          
          // Bar chart with goal line (like week view)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                // Goal line overlay
                Positioned(
                  left: 50,
                  right: 16,
                  bottom: baseBarHeight + 14, // Position at 100% goal level + space for labels
                  child: Container(
                    height: 1,
                    color: Colors.green[600],
                  ),
                ),
                
                // Y-axis labels and bars
                Row(
                  children: [
                    // Y-axis labels
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
                    // Bars with goal line logic
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
                                  barColor = Colors.red[300]!; // Light red when over goal
                                } else {
                                  barColor = Colors.purple[300]!; // Purple for normal/under goal
                                }
                                
                                // Calculate bar height: goal (1.0) = baseBarHeight
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
                          // X-axis labels
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
          
          // Statistics section (like week view)
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
                // Average calories per month
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average calories per month',
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
                
                // Total monthly and percentage
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
                
                // Goal achievement breakdown (like week view)
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
          
          const SizedBox(height: 20), // Bottom padding
        ],
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