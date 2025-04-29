class NutrientGoal {
  final int target;
  final int current;
  final String unit;

  NutrientGoal({
    required this.target,
    required this.current,
    required this.unit,
  });

  double get progress => current / target;
}