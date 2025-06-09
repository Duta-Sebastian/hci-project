import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/meal.dart';
import '../services/meal_database.dart';

class AddEntryScreen extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const AddEntryScreen({
    super.key,
    this.onDataChanged,
  });

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final DateTime _selectedDate = DateTime.now();
  String _mealType = 'breakfast';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _availableFoodItems = [];
  Set<String> _existingMealNames = {}; // Track existing meals for current type
  bool _isAddingFood = false;
  
  @override
  void initState() {
    super.initState();
    _availableFoodItems = [
      {
        'name': 'Eggs',
        'calories': 140,
        'nutrients': {'carbs': 1.1, 'protein': 13.0, 'fat': 9.5},
      },
      {
        'name': 'Bread',
        'calories': 265,
        'nutrients': {'carbs': 49.0, 'protein': 9.0, 'fat': 3.2},
      },
      {
        'name': 'Tomato',
        'calories': 22,
        'nutrients': {'carbs': 4.8, 'protein': 1.1, 'fat': 0.2},
      },
      {
        'name': 'Banana',
        'calories': 105,
        'nutrients': {'carbs': 27.0, 'protein': 1.3, 'fat': 0.4},
      },
      {
        'name': 'Chicken Breast',
        'calories': 165,
        'nutrients': {'carbs': 0.0, 'protein': 31.0, 'fat': 3.6},
      },
      {
        'name': 'Rice',
        'calories': 130,
        'nutrients': {'carbs': 28.0, 'protein': 2.7, 'fat': 0.3},
      },
    ];
    _loadExistingMeals();
  }

  Future<void> _loadExistingMeals() async {
    try {
      final meals = await MealDatabase.instance.getMealsGroupedByTypeForDate(_selectedDate);
      setState(() {
        _existingMealNames = (meals[_mealType] ?? []).map((meal) => meal.name).toSet();
      });
    } catch (e) {
      debugPrint('Error loading existing meals: $e');
    }
  }

  Future<void> _addFoodItem(Map<String, dynamic> item) async {
    setState(() {
      _isAddingFood = true;
    });
    
    try {
      final meal = Meal(
        name: item['name'],
        calories: item['calories'],
        nutrients: {
          'carbs': item['nutrients']['carbs'] as double,
          'protein': item['nutrients']['protein'] as double,
          'fat': item['nutrients']['fat'] as double,
        },
        mealType: _mealType,
        date: _selectedDate,
      );
      
      await MealDatabase.instance.addMeal(meal);
      
      if (mounted) {
        // Add to existing meals set to hide it from the list
        setState(() {
          _existingMealNames.add(item['name']);
        });
        
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${item['name']} to $_mealType'),
            duration: const Duration(milliseconds: 800),
            backgroundColor: Colors.green[600],
          ),
        );
        
        // Call onDataChanged for instant update
        if (widget.onDataChanged != null) {
          widget.onDataChanged!();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding food: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingFood = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    final baseFilter = _searchController.text.isEmpty 
        ? _availableFoodItems
        : _availableFoodItems
            .where((item) => item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
    
    // Filter out items that already exist in the current meal type
    return baseFilter
        .where((item) => !_existingMealNames.contains(item['name']))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Don't call onDataChanged in dispose to prevent crashes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Text(DateFormat('MMMM d').format(_selectedDate)),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return !_isAddingFood;
        },
        child: Column(
          children: [
            if (_isAddingFood) 
              const LinearProgressIndicator(),
              
            // Meal Type Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMealTypeButton('breakfast', 'Breakfast'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMealTypeButton('lunch', 'Lunch'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMealTypeButton('dinner', 'Dinner'),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                enabled: !_isAddingFood,
                decoration: InputDecoration(
                  hintText: 'Search for a product',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: _isAddingFood ? Colors.grey[100] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            
            // Category tabs
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: _isAddingFood ? const NeverScrollableScrollPhysics() : null,
                child: Row(
                  children: [
                    _buildCategoryChip('All', isSelected: true),
                    _buildCategoryChip('Grains'),
                    _buildCategoryChip('Dairy'),
                    _buildCategoryChip('Protein'),
                    _buildCategoryChip('Fruits'),
                    _buildCategoryChip('Fats'),
                  ],
                ),
              ),
            ),
            
            // Food items list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _getFilteredItems().length,
                physics: _isAddingFood ? const NeverScrollableScrollPhysics() : null,
                itemBuilder: (context, index) {
                  final item = _getFilteredItems()[index];
                  final isAvailable = !_existingMealNames.contains(item['name']);
                  
                  return InkWell(
                    onTap: (_isAddingFood || !isAvailable) ? null : () => _addFoodItem(item),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isAvailable 
                          ? Colors.grey[100] 
                          : _isAddingFood 
                            ? Colors.grey[50] 
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          item['name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isAvailable ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(
                          '${item['calories']} kcal',
                          style: TextStyle(
                            color: !isAvailable ? Colors.grey : null,
                          ),
                        ),
                        trailing: !isAvailable 
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange[300]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit, size: 16, color: Colors.orange[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Use counter',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${(item['nutrients']['carbs'] as double).toStringAsFixed(1)} g'),
                                const Text('Carbs', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${(item['nutrients']['protein'] as double).toStringAsFixed(1)} g'),
                                const Text('Protein', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${(item['nutrients']['fat'] as double).toStringAsFixed(1)} g'),
                                const Text('Fat', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        enabled: !_isAddingFood,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isAddingFood 
          ? null 
          : () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barcode scanner not implemented')),
              );
            },
        backgroundColor: _isAddingFood ? Colors.grey : Colors.purple[300],
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
  
  Widget _buildMealTypeButton(String type, String label) {
    final isSelected = _mealType == type;
    
    return ElevatedButton(
      onPressed: _isAddingFood 
        ? null 
        : () {
            setState(() {
              _mealType = type;
            });
            _loadExistingMeals(); // Reload existing meals for new type
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
          ? Colors.green[300] 
          : Colors.grey[200],
        foregroundColor: isSelected 
          ? Colors.white 
          : Colors.grey[700],
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.green[200],
        onSelected: _isAddingFood 
          ? null 
          : (selected) {
              // Filter by category - not implemented in this simple version
            },
      ),
    );
  }
}