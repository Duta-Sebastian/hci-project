import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_database.dart';

class MealGroup {
  final String name;
  final List<Meal> meals;
  final int quantity;
  final int totalCalories;
  final Map<String, double> totalNutrients;

  MealGroup({
    required this.name,
    required this.meals,
    required this.quantity,
    required this.totalCalories,
    required this.totalNutrients,
  });
}

class DailyMealsWidget extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onDataChanged;
  final Function(VoidCallback) onRefreshCallbackSet; // Add this parameter

  const DailyMealsWidget({
    super.key,
    required this.selectedDate,
    required this.onDataChanged,
    required this.onRefreshCallbackSet, // Add this parameter
  });

  @override
  State<DailyMealsWidget> createState() => _DailyMealsWidgetState();
}

class _DailyMealsWidgetState extends State<DailyMealsWidget> {
  Map<String, List<MealGroup>> _cachedMealGroups = {};
  Map<String, bool> expandedState = {
    'breakfast': false,
    'lunch': false,
    'dinner': false,
  };
  
  // Local state for smooth counter updates
  Map<String, Map<String, int>> _localQuantities = {};
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadMealsData();
    // Register the refresh callback with the parent
    widget.onRefreshCallbackSet(_loadMealsData);
  }

  @override
  void didUpdateWidget(DailyMealsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadMealsData();
    }
    // Re-register callback if it changed
    if (oldWidget.onRefreshCallbackSet != widget.onRefreshCallbackSet) {
      widget.onRefreshCallbackSet(_loadMealsData);
    }
  }

  Future<void> _loadMealsData() async {
    try {
      final mealsMap = await MealDatabase.instance.getMealsGroupedByTypeForDate(widget.selectedDate);
      
      if (mounted) {
        setState(() {
          _cachedMealGroups = {
            'breakfast': _groupMealsByName(mealsMap['breakfast'] ?? []),
            'lunch': _groupMealsByName(mealsMap['lunch'] ?? []),
            'dinner': _groupMealsByName(mealsMap['dinner'] ?? []),
          };
          // Reset local quantities when loading fresh data
          _localQuantities.clear();
        });
      }
    } catch (e) {
      debugPrint('Error loading meals: $e');
    }
  }

  List<MealGroup> _groupMealsByName(List<Meal> meals) {
    Map<String, List<Meal>> groupedMeals = {};
    
    for (var meal in meals) {
      if (groupedMeals.containsKey(meal.name)) {
        groupedMeals[meal.name]!.add(meal);
      } else {
        groupedMeals[meal.name] = [meal];
      }
    }
    
    return groupedMeals.entries.map((entry) {
      final mealsList = entry.value;
      final totalCalories = mealsList.fold(0, (sum, meal) => sum + meal.calories);
      final totalNutrients = <String, double>{
        'carbs': mealsList.fold(0.0, (sum, meal) => sum + (meal.nutrients['carbs'] ?? 0)),
        'protein': mealsList.fold(0.0, (sum, meal) => sum + (meal.nutrients['protein'] ?? 0)),
        'fat': mealsList.fold(0.0, (sum, meal) => sum + (meal.nutrients['fat'] ?? 0)),
      };
      
      return MealGroup(
        name: entry.key,
        meals: mealsList,
        quantity: mealsList.length,
        totalCalories: totalCalories,
        totalNutrients: totalNutrients,
      );
    }).toList();
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
          Column(
            children: [
              _buildMealCategory('breakfast', _cachedMealGroups['breakfast'] ?? []),
              _buildMealCategory('lunch', _cachedMealGroups['lunch'] ?? []),
              _buildMealCategory('dinner', _cachedMealGroups['dinner'] ?? []),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealCategory(String mealType, List<MealGroup> groupedMeals) {
    final hasMeals = groupedMeals.isNotEmpty;
    final isExpanded = expandedState[mealType] ?? false;
    
    int totalCalories = 0;
    Map<String, double> totalNutrients = {
      'carbs': 0.0,
      'protein': 0.0,
      'fat': 0.0,
    };
    
    for (var group in groupedMeals) {
      // Use local quantities if available
      final localQuantity = _localQuantities[mealType]?[group.name] ?? group.quantity;
      final multiplier = localQuantity / group.quantity;
      
      totalCalories += (group.totalCalories * multiplier).round();
      totalNutrients['carbs'] = (totalNutrients['carbs'] ?? 0) + (group.totalNutrients['carbs']! * multiplier);
      totalNutrients['protein'] = (totalNutrients['protein'] ?? 0) + (group.totalNutrients['protein']! * multiplier);
      totalNutrients['fat'] = (totalNutrients['fat'] ?? 0) + (group.totalNutrients['fat']! * multiplier);
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
              itemCount: groupedMeals.length,
              itemBuilder: (context, index) {
                final mealGroup = groupedMeals[index];
                return _buildMealGroupItem(mealGroup, mealType);
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

  Widget _buildMealGroupItem(MealGroup mealGroup, String mealType) {
    // Use local quantity if available, otherwise use actual quantity
    final displayQuantity = _localQuantities[mealType]?[mealGroup.name] ?? mealGroup.quantity;
    final multiplier = displayQuantity / mealGroup.quantity;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealGroup.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(mealGroup.totalCalories * multiplier).round()} kcal',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildNutrientValue((mealGroup.totalNutrients['carbs'] ?? 0) * multiplier, 'g'),
          const SizedBox(width: 24),
          _buildNutrientValue((mealGroup.totalNutrients['protein'] ?? 0) * multiplier, 'g'),
          const SizedBox(width: 24),
          _buildNutrientValue((mealGroup.totalNutrients['fat'] ?? 0) * multiplier, 'g'),
          const SizedBox(width: 12),
          // Quantity counter
          _buildQuantityCounter(mealGroup, mealType),
        ],
      ),
    );
  }

  Widget _buildQuantityCounter(MealGroup mealGroup, String mealType) {
    // Use local quantity if available, otherwise use actual quantity
    final displayQuantity = _localQuantities[mealType]?[mealGroup.name] ?? mealGroup.quantity;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _isUpdating ? null : () => _decrementQuantity(mealGroup, mealType),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: displayQuantity > 0 ? Colors.red[50] : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: 16,
                color: displayQuantity > 0 ? Colors.red[600] : Colors.grey[400],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: Text(
              '$displayQuantity',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: _isUpdating ? null : () => _incrementQuantity(mealGroup, mealType),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: Colors.green[600],
              ),
            ),
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

  Future<void> _incrementQuantity(MealGroup mealGroup, String mealType) async {
    if (_isUpdating) return;
    
    // Update local state immediately for smooth UI
    setState(() {
      _localQuantities[mealType] ??= {};
      final currentLocal = _localQuantities[mealType]![mealGroup.name] ?? mealGroup.quantity;
      _localQuantities[mealType]![mealGroup.name] = currentLocal + 1;
      _isUpdating = true;
    });
    
    try {
      // Add one more meal of this type
      final sampleMeal = mealGroup.meals.first;
      final newMeal = Meal(
        name: sampleMeal.name,
        calories: sampleMeal.calories,
        nutrients: Map<String, double>.from(sampleMeal.nutrients),
        mealType: mealType,
        date: widget.selectedDate,
      );
      
      await MealDatabase.instance.addMeal(newMeal);
      
      // Call data changed callback for nutrition updates
      widget.onDataChanged();
      
      // Update cached data without full reload
      await _updateCachedMeal(mealGroup.name, mealType, 1);
      
    } catch (e) {
      // Revert local state on error
      if (mounted) {
        setState(() {
          final currentLocal = _localQuantities[mealType]![mealGroup.name] ?? mealGroup.quantity + 1;
          _localQuantities[mealType]![mealGroup.name] = currentLocal - 1;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _decrementQuantity(MealGroup mealGroup, String mealType) async {
    if (_isUpdating) return;
    
    final currentQuantity = _localQuantities[mealType]?[mealGroup.name] ?? mealGroup.quantity;
    if (currentQuantity <= 0) return;
    
    final newQuantity = currentQuantity - 1;
    
    // Update local state immediately for smooth UI
    setState(() {
      _localQuantities[mealType] ??= {};
      _localQuantities[mealType]![mealGroup.name] = newQuantity;
      _isUpdating = true;
    });
    
    try {
      // Remove one meal of this type
      final mealToRemove = mealGroup.meals.last;
      await MealDatabase.instance.deleteMeal(mealToRemove.id);
      
      // Call data changed callback for nutrition updates
      widget.onDataChanged();
      
      // If quantity is now 0, remove from cached list
      if (newQuantity == 0) {
        await _removeMealGroupFromCache(mealGroup.name, mealType);
      } else {
        // Update cached data without full reload
        await _updateCachedMeal(mealGroup.name, mealType, -1);
      }
      
    } catch (e) {
      // Revert local state on error
      if (mounted) {
        setState(() {
          _localQuantities[mealType]![mealGroup.name] = currentQuantity;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _removeMealGroupFromCache(String mealName, String mealType) async {
    if (mounted) {
      setState(() {
        final currentGroups = _cachedMealGroups[mealType] ?? [];
        currentGroups.removeWhere((group) => group.name == mealName);
        _cachedMealGroups[mealType] = currentGroups;
        
        // Clear local quantity for this meal
        _localQuantities[mealType]?.remove(mealName);
      });
    }
  }

  Future<void> _updateCachedMeal(String mealName, String mealType, int delta) async {
    // Update the cached meal groups without full page reload
    if (mounted) {
      setState(() {
        final currentGroups = _cachedMealGroups[mealType] ?? [];
        bool foundGroup = false;
        
        for (int i = 0; i < currentGroups.length; i++) {
          if (currentGroups[i].name == mealName) {
            foundGroup = true;
            final group = currentGroups[i];
            if (delta > 0) {
              // Add a meal
              group.meals.add(group.meals.first); // Duplicate the first meal
            } else if (group.meals.isNotEmpty) {
              // Remove a meal
              group.meals.removeLast();
            }
            
            // Update the group's quantity and totals
            final newGroup = MealGroup(
              name: group.name,
              meals: group.meals,
              quantity: group.meals.length,
              totalCalories: group.meals.fold(0, (sum, meal) => sum + meal.calories),
              totalNutrients: {
                'carbs': group.meals.fold(0.0, (sum, meal) => sum + (meal.nutrients['carbs'] ?? 0)),
                'protein': group.meals.fold(0.0, (sum, meal) => sum + (meal.nutrients['protein'] ?? 0)),
                'fat': group.meals.fold(0.0, (sum, meal) => sum + (meal.nutrients['fat'] ?? 0)),
              },
            );
            
            currentGroups[i] = newGroup;
            break;
          }
        }
        
        // If we didn't find the group and delta is positive, it means a new meal was added
        // Reload the data to get the new meal
        if (!foundGroup && delta > 0) {
          _loadMealsData();
        }
      });
    }
  }
}