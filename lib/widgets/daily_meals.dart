import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_database.dart';

class DailyMealsWidget extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onDataChanged;

  const DailyMealsWidget({
    super.key,
    required this.selectedDate,
    required this.onDataChanged,
  });

  @override
  State<DailyMealsWidget> createState() => _DailyMealsWidgetState();
}

class _DailyMealsWidgetState extends State<DailyMealsWidget> {
  late Future<Map<String, List<Meal>>> _mealsFuture;
  Map<String, bool> expandedState = {
    'breakfast': false,
    'lunch': false,
    'dinner': false,
  };

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  @override
  void didUpdateWidget(DailyMealsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadMeals();
    }
  }

  void _loadMeals() {
    _mealsFuture = MealDatabase.instance.getMealsGroupedByTypeForDate(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your meals',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle "View all" action
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<Map<String, List<Meal>>>(
            future: _mealsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              if (!snapshot.hasData) {
                return const Center(child: Text('No meals found'));
              }
              
              final mealsByType = snapshot.data!;
              
              return Column(
                children: [
                  _buildMealCategory('breakfast', mealsByType['breakfast'] ?? []),
                  _buildMealCategory('lunch', mealsByType['lunch'] ?? []),
                  _buildMealCategory('dinner', mealsByType['dinner'] ?? []),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealCategory(String mealType, List<Meal> meals) {
    final hasMeals = meals.isNotEmpty;
    final isExpanded = expandedState[mealType] ?? false;
    
    int totalCalories = 0;
    Map<String, double> totalNutrients = {
      'carbs': 0.0,
      'protein': 0.0,
      'fat': 0.0,
    };
    
    for (var meal in meals) {
      totalCalories += meal.calories;
      totalNutrients['carbs'] = (totalNutrients['carbs'] ?? 0) + (meal.nutrients['carbs'] ?? 0);
      totalNutrients['protein'] = (totalNutrients['protein'] ?? 0) + (meal.nutrients['protein'] ?? 0);
      totalNutrients['fat'] = (totalNutrients['fat'] ?? 0) + (meal.nutrients['fat'] ?? 0);
    }
    
    final displayType = mealType[0].toUpperCase() + mealType.substring(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (hasMeals) {
                setState(() {
                  expandedState[mealType] = !isExpanded;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildNutrientColumn('Carbs', totalNutrients['carbs'] ?? 0),
                        const SizedBox(width: 12),
                        _buildNutrientColumn('Protein', totalNutrients['protein'] ?? 0),
                        const SizedBox(width: 12),
                        _buildNutrientColumn('Fat', totalNutrients['fat'] ?? 0),
                        const SizedBox(width: 8),
                        Icon(
                          hasMeals
                              ? (isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                              : null,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasMeals) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$totalCalories kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isExpanded && hasMeals)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return _buildMealItem(meal);
              },
            ),
          if (!hasMeals)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No meals are added',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMealItem(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal.calories} kcal',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildNutrientValue(meal.nutrients['carbs'] ?? 0, 'g'),
          const SizedBox(width: 24),
          _buildNutrientValue(meal.nutrients['protein'] ?? 0, 'g'),
          const SizedBox(width: 24),
          _buildNutrientValue(meal.nutrients['fat'] ?? 0, 'g'),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () => _deleteMeal(meal),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientColumn(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}g',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientValue(double value, String unit) {
    return SizedBox(
      width: 32,
      child: Text(
        '${value.toStringAsFixed(1)}$unit',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  // Delete meal
  void _deleteMeal(Meal meal) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await MealDatabase.instance.deleteMeal(meal.id);
      setState(() {
        _loadMeals();
      });
      
      widget.onDataChanged();
    }
  }
}