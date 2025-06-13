import 'package:flutter/material.dart';

class FiltersModal extends StatefulWidget {
  final Set<String> selectedTimeFilters;
  final Set<String> selectedMacroFilters;
  final Set<String> selectedDietFilters;
  final Function(Set<String>, Set<String>, Set<String>) onFiltersChanged;

  const FiltersModal({
    super.key,
    required this.selectedTimeFilters,
    required this.selectedMacroFilters,
    required this.selectedDietFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FiltersModal> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  late Set<String> timeFilters;
  late Set<String> macroFilters;
  late Set<String> dietFilters;

  @override
  void initState() {
    super.initState();
    timeFilters = Set.from(widget.selectedTimeFilters);
    macroFilters = Set.from(widget.selectedMacroFilters);
    dietFilters = Set.from(widget.selectedDietFilters);
  }

  void _updateFilters() {
    widget.onFiltersChanged(timeFilters, macroFilters, dietFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Filters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      timeFilters.clear();
                      macroFilters.clear();
                      dietFilters.clear();
                    });
                    _updateFilters();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      color: Color(0xFFB794F6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('Time', [
                    '5 - 15 min',
                    '15 - 20 min',
                    '30 + min',
                  ], timeFilters),
                  const SizedBox(height: 24),
                  _buildFilterSection('Macro Focus', [
                    'Carbs',
                    'Protein',
                    'Fats',
                  ], macroFilters),
                  const SizedBox(height: 24),
                  _buildFilterSection('Diet Restriction', [
                    'Vegetarian',
                    'Vegan',
                    'Pescatarian',
                    'Lactose-free',
                    'Gluten-free',
                  ], dietFilters),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, Set<String> selectedFilters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedFilters.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedFilters.remove(option);
                  } else {
                    selectedFilters.add(option);
                  }
                });
                _updateFilters();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFB794F6) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}