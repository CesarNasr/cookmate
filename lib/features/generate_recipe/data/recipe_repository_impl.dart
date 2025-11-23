
import 'package:cookmate/core/models/recipe_list_container.dart';
import 'package:cookmate/core/utils/resource.dart';

import '../../../core/services/ai/gemini_service.dart';
import '../domain/recipe_repository.dart';





class RecipeRepositoryImpl implements RecipeRepository {
  final GeminiService geminiService;

  RecipeRepositoryImpl(this.geminiService);

  @override
  Future<Resource<RecipeListContainer>> fetchRecipes(List<String> ingredients) {
    return geminiService.generateRecipes(ingredients);
  }
}