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
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _availableFoodItems = [];
  Set<String> _existingMealNames = {};
  bool _isAddingFood = false;
  
  @override
  void initState() {
    super.initState();
    _availableFoodItems = [
      // Protein
      {'name': 'Eggs', 'calories': 140, 'nutrients': {'carbs': 1.1, 'protein': 13.0, 'fat': 9.5}, 'category': 'Protein'},
      {'name': 'Chicken Breast', 'calories': 165, 'nutrients': {'carbs': 0.0, 'protein': 31.0, 'fat': 3.6}, 'category': 'Protein'},
      {'name': 'Grilled Chicken Breast', 'calories': 165, 'nutrients': {'carbs': 0.0, 'protein': 31.0, 'fat': 3.6}, 'category': 'Protein'},
      {'name': 'Salmon Fillet', 'calories': 206, 'nutrients': {'carbs': 0.0, 'protein': 22.0, 'fat': 12.0}, 'category': 'Protein'},
      
      // Grains
      {'name': 'Bread', 'calories': 265, 'nutrients': {'carbs': 49.0, 'protein': 9.0, 'fat': 3.2}, 'category': 'Grains'},
      {'name': 'Rice', 'calories': 130, 'nutrients': {'carbs': 28.0, 'protein': 2.7, 'fat': 0.3}, 'category': 'Grains'},
      {'name': 'Brown Rice', 'calories': 216, 'nutrients': {'carbs': 45.0, 'protein': 5.0, 'fat': 1.8}, 'category': 'Grains'},
      {'name': 'Quinoa', 'calories': 222, 'nutrients': {'carbs': 39.0, 'protein': 8.0, 'fat': 3.6}, 'category': 'Grains'},
      
      // Dairy
      {'name': 'Greek Yogurt', 'calories': 100, 'nutrients': {'carbs': 6.0, 'protein': 17.0, 'fat': 0.4}, 'category': 'Dairy'},
      
      // Fruits
      {'name': 'Banana', 'calories': 105, 'nutrients': {'carbs': 27.0, 'protein': 1.3, 'fat': 0.4}, 'category': 'Fruits'},
      {'name': 'Tomato', 'calories': 22, 'nutrients': {'carbs': 4.8, 'protein': 1.1, 'fat': 0.2}, 'category': 'Fruits'},
      
      // Vegetables
      {'name': 'Steamed Broccoli', 'calories': 34, 'nutrients': {'carbs': 7.0, 'protein': 3.0, 'fat': 0.4}, 'category': 'Vegetables'},
      {'name': 'Sweet Potato', 'calories': 112, 'nutrients': {'carbs': 26.0, 'protein': 2.0, 'fat': 0.1}, 'category': 'Vegetables'},
      
      // Fats
      {'name': 'Almonds', 'calories': 164, 'nutrients': {'carbs': 6.0, 'protein': 6.0, 'fat': 14.0}, 'category': 'Fats'},
      {'name': 'Avocado', 'calories': 234, 'nutrients': {'carbs': 12.0, 'protein': 3.0, 'fat': 21.0}, 'category': 'Fats'},
    ];
    _loadExistingMeals();
  }

  Future<void> _loadExistingMeals() async {
    try {
      final meals = await MealDatabase.instance.getMealsGroupedByTypeForDate(_selectedDate);
      if (mounted) {
        setState(() {
          _existingMealNames = (meals[_mealType] ?? []).map((meal) => meal.name).toSet();
        });
      }
    } catch (e) {
      debugPrint('Error loading existing meals: $e');
    }
  }

  void _showTopSnackBar(String message, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20, // Position below status bar
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? Colors.red[600] : Colors.green[600],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error : Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // Remove after duration
    Future.delayed(Duration(milliseconds: isError ? 2000 : 800), () {
      overlayEntry.remove();
    });
  }

  Future<int?> _showQuantityPicker(BuildContext context, String foodName) async {
    int selectedQuantity = 1;
    final item = _availableFoodItems.firstWhere((food) => food['name'] == foodName);
    
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final totalCalories = (item['calories'] as int) * selectedQuantity;
            final totalCarbs = (item['nutrients']['carbs'] as double) * selectedQuantity;
            final totalProtein = (item['nutrients']['protein'] as double) * selectedQuantity;
            final totalFat = (item['nutrients']['fat'] as double) * selectedQuantity;
            
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Add $foodName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'How many servings would you like to add?',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedQuantity > 1 
                            ? () {
                                setDialogState(() {
                                  selectedQuantity--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                        color: selectedQuantity > 1 ? Colors.red[600] : Colors.grey[400],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$selectedQuantity',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: selectedQuantity < 10
                            ? () {
                                setDialogState(() {
                                  selectedQuantity++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                        color: selectedQuantity < 10 ? Colors.green[600] : Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$totalCalories kcal',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${totalCarbs.toStringAsFixed(1)}g',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Text(
                                  'Carbs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${totalProtein.toStringAsFixed(1)}g',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Text(
                                  'Protein',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${totalFat.toStringAsFixed(1)}g',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Text(
                                  'Fat',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedQuantity),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addFoodItem(Map<String, dynamic> item) async {
    final quantity = await _showQuantityPicker(context, item['name']);
    if (quantity == null || quantity <= 0) return;
    
    setState(() {
      _isAddingFood = true;
    });
    
    try {
      for (int i = 0; i < quantity; i++) {
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
      }
      
      if (mounted) {
        setState(() {
          _existingMealNames.add(item['name']);
        });
        
        _showTopSnackBar('Added $quantity x ${item['name']} to $_mealType');
      }
    } catch (e) {
      if (mounted) {
        _showTopSnackBar('Error adding food: $e', isError: true);
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
    var items = _availableFoodItems;
    
    if (_selectedCategory != 'All') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      items = items
          .where((item) => item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
    
    return items
        .where((item) => !_existingMealNames.contains(item['name']))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    
    if (widget.onDataChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDataChanged!();
      });
    }
    
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
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: _isAddingFood ? const NeverScrollableScrollPhysics() : null,
                child: Row(
                  children: [
                    _buildCategoryChip('All', isSelected: _selectedCategory == 'All'),
                    _buildCategoryChip('Grains', isSelected: _selectedCategory == 'Grains'),
                    _buildCategoryChip('Dairy', isSelected: _selectedCategory == 'Dairy'),
                    _buildCategoryChip('Protein', isSelected: _selectedCategory == 'Protein'),
                    _buildCategoryChip('Fruits', isSelected: _selectedCategory == 'Fruits'),
                    _buildCategoryChip('Fats', isSelected: _selectedCategory == 'Fats'),
                    _buildCategoryChip('Vegetables', isSelected: _selectedCategory == 'Vegetables'),
                  ],
                ),
              ),
            ),
            
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
              _showTopSnackBar('Barcode scanner not implemented');
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
            _loadExistingMeals();
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
              setState(() {
                _selectedCategory = label;
              });
            },
      ),
    );
  }
}