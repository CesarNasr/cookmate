
import 'Recipe.dart';

class RecipeListContainer {
  final List<Recipe> recipes;

  RecipeListContainer({required this.recipes});

  factory RecipeListContainer.fromJson(Map<String, dynamic> json) {
    return RecipeListContainer(
      // Access the 'recipes' key and map the list of maps to Recipe objects
      recipes: (json['recipes'] as List<dynamic>)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}