import 'package:flutter/material.dart';
import 'package:project/models/meal.dart';
import 'package:project/models/meal_suggestion.dart';
import 'package:project/services/meal_database.dart';


class QuantitySelectionModal extends StatefulWidget {
  final MealSuggestion meal;

  const QuantitySelectionModal({super.key, required this.meal});

  @override
  State<QuantitySelectionModal> createState() => _QuantitySelectionModalState();
}

class _QuantitySelectionModalState extends State<QuantitySelectionModal> {
  int servings = 1;
  String selectedMealType = 'breakfast';

  String _getCurrentMealType() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'breakfast';
    if (hour < 16) return 'lunch';
    return 'dinner';
  }

  @override
  void initState() {
    super.initState();
    selectedMealType = _getCurrentMealType();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.meal.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMealTypeOption('breakfast', 'Breakfast', Icons.wb_sunny),
              _buildMealTypeOption('lunch', 'Lunch', Icons.wb_sunny_outlined),
              _buildMealTypeOption('dinner', 'Dinner', Icons.nights_stay),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Servings: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (servings > 1) {
                      setState(() {
                        servings--;
                      });
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: servings > 1 ? const Color(0xFFB794F6) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 12,
                      color: servings > 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  servings.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (servings < 10) {
                      setState(() {
                        servings++;
                      });
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: servings < 10 ? const Color(0xFFB794F6) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 12,
                      color: servings < 10 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNutritionItem(
                    'Cal', 
                    (widget.meal.calories * servings).toString(), 
                    Colors.orange
                  ),
                  _buildNutritionItem(
                    'Carbs', 
                    '${(double.parse(widget.meal.carbs.replaceAll('g', '')) * servings).toStringAsFixed(1)}g', 
                    const Color(0xFF9AE6B4)
                  ),
                  _buildNutritionItem(
                    'Protein', 
                    '${(double.parse(widget.meal.protein.replaceAll('g', '')) * servings).toStringAsFixed(1)}g', 
                    Colors.orange
                  ),
                  _buildNutritionItem(
                    'Fat', 
                    '${(double.parse(widget.meal.fat.replaceAll('g', '')) * servings).toStringAsFixed(1)}g', 
                    const Color(0xFF9AE6B4)
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: GestureDetector(
              onTap: () => _saveMeal(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB794F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Add to Meal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeOption(String type, String label, IconData icon) {
    final isSelected = selectedMealType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMealType = type;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFB794F6).withOpacity(0.2) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFFB794F6) : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? const Color(0xFFB794F6) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveMeal() async {
    final meal = Meal(
      name: widget.meal.name,
      calories: widget.meal.calories * servings,
      nutrients: {
        'carbs': double.parse(widget.meal.carbs.replaceAll('g', '')) * servings,
        'protein': double.parse(widget.meal.protein.replaceAll('g', '')) * servings,
        'fat': double.parse(widget.meal.fat.replaceAll('g', '')) * servings,
      },
      mealType: selectedMealType,
      date: DateTime.now(),
    );

    await MealDatabase.instance.addMeal(meal);
    
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.meal.name} (${servings} serving${servings > 1 ? 's' : ''}) added to $selectedMealType!'),
          backgroundColor: const Color(0xFF9AE6B4),
        ),
      );
    }
  }
}