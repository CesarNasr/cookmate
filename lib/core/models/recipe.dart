import 'ingredient.dart';

class Recipe {
  final String title;
  final List<String> descriptionLabels;
  final String level;
  final String duration;
  final List<Ingredient> ingredients; // Uses the Ingredient model
  final List<String> instructions;

  Recipe({
    required this.title,
    required this.descriptionLabels,
    required this.level,
    required this.duration,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String,
      // Map the dynamic list to a List<String>
      descriptionLabels: (json['description_labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      level: json['level'] as String,
      duration: json['duration'] as String,
      // Map the dynamic list to a List<Ingredient>
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Map the dynamic list to a List<String>
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}