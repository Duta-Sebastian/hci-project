import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
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
  
  @override
  void initState() {
    super.initState();
    // Sample food items
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
    ];
  }

  // Add food item directly to the database
  Future<void> _addFoodItemDirectly(Map<String, dynamic> item) async {
    try {
      // Create a meal from the selected food item
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
      
      // Save to database
      await MealDatabase.instance.addMeal(meal);

      if (widget.onDataChanged != null) {
        widget.onDataChanged!();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${item['name']} to $_mealType')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding food: $e')),
      );
    }
  }

  // This function is removed as we're now adding items directly

  List<Map<String, dynamic>> _getFilteredItems() {
    if (_searchController.text.isEmpty) {
      return _availableFoodItems;
    }
    return _availableFoodItems
        .where((item) => item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
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
            const BackButton(),
            Text(DateFormat('MMMM d').format(_selectedDate)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Select Meal Type'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          setState(() { _mealType = 'breakfast'; });
                          Navigator.pop(context);
                        },
                        child: const Text('Breakfast'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          setState(() { _mealType = 'lunch'; });
                          Navigator.pop(context);
                        },
                        child: const Text('Lunch'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          setState(() { _mealType = 'dinner'; });
                          Navigator.pop(context);
                        },
                        child: const Text('Dinner'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(double.infinity, 40),
              ),
              child: Text(_mealType.capitalize()),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a product',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Update the filtered list on every letter typed
                setState(() {});
              },
            ),
          ),
          
          // Category tabs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
              itemBuilder: (context, index) {
                final item = _getFilteredItems()[index];
                return ListTile(
                  title: Text(
                    item['name'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${item['calories']} kcal'),
                  trailing: Row(
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
                  onTap: () => _addFoodItemDirectly(item),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for barcode scanner
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barcode scanner not implemented')),
          );
        },
        backgroundColor: Colors.purple[300],
        child: const Icon(Icons.qr_code_scanner),
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
        onSelected: (selected) {
          // Filter by category - not implemented in this simple version
        },
      ),
    );
  }
}

// Extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}