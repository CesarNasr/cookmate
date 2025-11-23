// The Provider definition is correct, assuming you've defined RecipeRepository and RecipeRepositoryImpl elsewhere.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/ai/gemini_service.dart';
import '../features/generate_recipe/data/recipe_repository_impl.dart';
import '../features/generate_recipe/domain/recipe_repository.dart';

final recipesRepositoryProvider = Provider<RecipeRepository>((ref) {
  final geminiService = GeminiService();

  // Passing the service to the constructor
  return RecipeRepositoryImpl(geminiService);
});