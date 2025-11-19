
import 'package:cookmate/core/models/RecipeListContainer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/ai/gemini_service.dart';
import '../domain/RecipeRepository.dart';


// The Provider definition is correct, assuming you've defined RecipeRepository and RecipeRepositoryImpl elsewhere.
final recipesRepositoryProvider = Provider<RecipeRepository>((ref) {
  final geminiService = GeminiService();

  // Passing the service to the constructor
  return RecipeRepositoryImpl(geminiService);
});


class RecipeRepositoryImpl implements RecipeRepository {
  final GeminiService geminiService;

  RecipeRepositoryImpl(this.geminiService);

  @override
  Future<RecipeListContainer> fetchRecipes(List<String> ingredients) {
    return geminiService.generateRecipes(ingredients);
  }
}