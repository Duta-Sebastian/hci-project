import 'package:flutter/material.dart';
import 'package:project/models/meal_suggestion.dart';
import 'package:project/widgets/suggestions/filters_modal.dart';
import 'package:project/widgets/suggestions/meal_card.dart';
import 'package:project/widgets/suggestions/meal_detail_modal.dart';

class MealSuggestionsScreen extends StatefulWidget {
  const MealSuggestionsScreen({super.key});

  @override
  State<MealSuggestionsScreen> createState() => _MealSuggestionsScreenState();
}

class _MealSuggestionsScreenState extends State<MealSuggestionsScreen> {
  Set<String> selectedTimeFilters = {};
  Set<String> selectedMacroFilters = {};
  Set<String> selectedDietFilters = {};

  List<MealSuggestion> allMealSuggestions = [
    MealSuggestion(
      name: 'Grilled Chicken Salad',
      calories: 320,
      weight: '1.4g',
      protein: '3.5g',
      fat: '14.5g',
      carbs: '5.6g',
      image: '',
      tags: ['15 - 20 min', 'Protein', 'Gluten-free'],
      ingredients: [
        'Grilled chicken breast - 100g',
        'Cherry tomatoes - 50g',
        'Cucumber - 50g',
        'Mixed salad greens - 30g',
      ],
      preparation: [
        'Season the chicken breast with salt and pepper. Grill on medium heat for about 5-7 minutes per side, or until fully cooked. Slice into strips.',
        'Rinse and chop the cucumber and cherry tomatoes. Wash the salad greens thoroughly and let them dry.',
        'In a large bowl, combine salad greens, tomatoes, and cucumber. Place the grilled chicken slices on top of the salad.',
        'Drizzle with olive oil and lemon juice. Toss lightly to coat. Enjoy immediately while the chicken is warm, or refrigerate for a cold version later.',
      ],
    ),
    MealSuggestion(
      name: 'Vegetable Stir Fry',
      calories: 280,
      weight: '1.1g',
      protein: '2.8g',
      fat: '12.0g',
      carbs: '8.2g',
      image: '',
      tags: ['5 - 15 min', 'Vegetarian', 'Vegan', 'Carbs'],
      ingredients: [
        'Mixed vegetables - 200g',
        'Soy sauce - 2 tbsp',
        'Garlic - 2 cloves',
        'Ginger - 1 tsp',
      ],
      preparation: [
        'Heat oil in a wok or large pan over high heat.',
        'Add garlic and ginger, stir-fry for 30 seconds.',
        'Add vegetables and stir-fry for 3-4 minutes.',
        'Add soy sauce and toss to combine.',
      ],
    ),
    MealSuggestion(
      name: 'Greek Yogurt with Fruits',
      calories: 180,
      weight: '0.8g',
      protein: '15.0g',
      fat: '5.0g',
      carbs: '20.0g',
      image: '',
      tags: ['5 - 15 min', 'Protein', 'Vegetarian'],
      ingredients: [
        'Greek yogurt - 150g',
        'Mixed berries - 50g',
        'Honey - 1 tbsp',
        'Granola - 2 tbsp',
      ],
      preparation: [
        'Place Greek yogurt in a bowl.',
        'Top with mixed berries and granola.',
        'Drizzle with honey.',
        'Serve immediately.',
      ],
    ),
    MealSuggestion(
      name: 'Salmon Fillet',
      calories: 450,
      weight: '2.1g',
      protein: '25.0g',
      fat: '18.0g',
      carbs: '2.0g',
      image: '',
      tags: ['15 - 20 min', 'Protein', 'Pescatarian', 'Fats'],
      ingredients: [
        'Salmon fillet - 150g',
        'Lemon - 1 slice',
        'Olive oil - 1 tbsp',
        'Herbs - mixed',
      ],
      preparation: [
        'Preheat oven to 200°C.',
        'Season salmon with salt, pepper, and herbs.',
        'Drizzle with olive oil and lemon juice.',
        'Bake for 12-15 minutes until cooked through.',
      ],
    ),
    MealSuggestion(
      name: 'Quinoa Bowl',
      calories: 380,
      weight: '1.8g',
      protein: '12.0g',
      fat: '8.0g',
      carbs: '65.0g',
      image: '',
      tags: ['30 + min', 'Vegan', 'Gluten-free', 'Carbs'],
      ingredients: [
        'Quinoa - 100g',
        'Black beans - 50g',
        'Avocado - 1/2 piece',
        'Cherry tomatoes - 100g',
      ],
      preparation: [
        'Cook quinoa according to package instructions.',
        'Drain and rinse black beans.',
        'Slice avocado and halve cherry tomatoes.',
        'Combine all ingredients in a bowl.',
      ],
    ),
    MealSuggestion(
      name: 'Protein Smoothie',
      calories: 250,
      weight: '0.5g',
      protein: '20.0g',
      fat: '6.0g',
      carbs: '25.0g',
      image: '',
      tags: ['5 - 15 min', 'Protein', 'Lactose-free'],
      ingredients: [
        'Plant protein powder - 30g',
        'Banana - 1 medium',
        'Almond milk - 200ml',
        'Spinach - 1 handful',
      ],
      preparation: [
        'Add all ingredients to blender.',
        'Blend until smooth.',
        'Pour into glass and serve immediately.',
      ],
    ),
  ];

  List<MealSuggestion> get filteredMealSuggestions {
    return allMealSuggestions.where((meal) {
      bool matchesTime = selectedTimeFilters.isEmpty || 
          selectedTimeFilters.any((filter) => meal.tags.contains(filter));
      
      bool matchesMacro = selectedMacroFilters.isEmpty || 
          selectedMacroFilters.any((filter) => meal.tags.contains(filter));
      
      bool matchesDiet = selectedDietFilters.isEmpty || 
          selectedDietFilters.any((filter) => meal.tags.contains(filter));
      
      return matchesTime && matchesMacro && matchesDiet;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Meal suggestions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune,
              color: (selectedTimeFilters.isNotEmpty || 
                     selectedMacroFilters.isNotEmpty || 
                     selectedDietFilters.isNotEmpty) 
                  ? const Color(0xFFB794F6) 
                  : Colors.black,
            ),
            onPressed: () => _showFiltersModal(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredMealSuggestions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No meals match your filters',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters to see more options',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMealSuggestions.length,
                    itemBuilder: (context, index) {
                      return MealCard(
                        meal: filteredMealSuggestions[index],
                        onTap: () => _showMealDetails(filteredMealSuggestions[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }


  void _showFiltersModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FiltersModal(
        selectedTimeFilters: selectedTimeFilters,
        selectedMacroFilters: selectedMacroFilters,
        selectedDietFilters: selectedDietFilters,
        onFiltersChanged: (timeFilters, macroFilters, dietFilters) {
          setState(() {
            selectedTimeFilters = timeFilters;
            selectedMacroFilters = macroFilters;
            selectedDietFilters = dietFilters;
          });
        },
      ),
    );
  }

  void _showMealDetails(MealSuggestion meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealDetailModal(meal: meal),
    );
  }
}