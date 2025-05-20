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
  // Track operations
  bool _isAddingFood = false;
  // Add a queue for operations
  final List<_PendingOperation> _pendingOperations = [];
  // Track whether we're currently processing the queue
  bool _isProcessingQueue = false;
  
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

  // Queue an operation instead of executing it immediately
  void _queueFoodItemOperation(Map<String, dynamic> item) {
    setState(() {
      _isAddingFood = true;
      _pendingOperations.add(_PendingOperation(item, _mealType));
    });
    
    // Start processing the queue if not already processing
    if (!_isProcessingQueue) {
      _processOperationQueue();
    }
  }
  
  // Process operations one at a time
  Future<void> _processOperationQueue() async {
    if (_pendingOperations.isEmpty) {
      setState(() {
        _isAddingFood = false;
        _isProcessingQueue = false;
      });
      return;
    }
    
    setState(() {
      _isProcessingQueue = true;
    });
    
    while (_pendingOperations.isNotEmpty) {
      if (!mounted) return; // Safety check
      
      final operation = _pendingOperations.first;
      
      try {
        // Create a meal from the operation data
        final meal = Meal(
          name: operation.item['name'],
          calories: operation.item['calories'],
          nutrients: {
            'carbs': operation.item['nutrients']['carbs'] as double,
            'protein': operation.item['nutrients']['protein'] as double,
            'fat': operation.item['nutrients']['fat'] as double,
          },
          mealType: operation.mealType,
          date: _selectedDate,
        );
        
        // Save to database
        await MealDatabase.instance.addMeal(meal);
        // Only show message if we're still mounted
      
        if (mounted) {
          // Clear any existing SnackBars before showing new one
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${operation.item['name']} to ${operation.mealType}'),
              duration: const Duration(milliseconds: 500), // Shorter duration
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          // Clear any existing SnackBars before showing error
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding food: $e'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
      
      // Remove the processed operation
      if (mounted) {
        setState(() {
          _pendingOperations.removeAt(0);
        });
      }
      
      // Small delay between operations
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    // All operations processed
    if (mounted) {
      setState(() {
        _isAddingFood = false;
        _isProcessingQueue = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    if (_searchController.text.isEmpty) {
      return _availableFoodItems;
    }
    return _availableFoodItems
        .where((item) => item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
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
        // Prevent back navigation during operations
        onWillPop: () async {
          return !_isAddingFood;
        },
        child: Column(
          children: [
            // Loading indicator
            if (_isAddingFood) 
              LinearProgressIndicator(
                // Show progress based on remaining operations
                value: _pendingOperations.isEmpty ? null : 1 - (_pendingOperations.length / (_pendingOperations.length + 1)),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isAddingFood 
                  ? null 
                  : () {
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
                  backgroundColor: _isAddingFood ? Colors.grey[300] : Colors.green[300],
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
                  return InkWell(
                    onTap: _isAddingFood ? null : () => _queueFoodItemOperation(item),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isAddingFood ? Colors.grey[100] : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
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

// Helper class to track pending operations
class _PendingOperation {
  final Map<String, dynamic> item;
  final String mealType;
  
  _PendingOperation(this.item, this.mealType);
}

// Extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}