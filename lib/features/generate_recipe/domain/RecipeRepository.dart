
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/RecipeListContainer.dart';


abstract class RecipeRepository {
  Future<RecipeListContainer> fetchRecipes(List<String> ingredients);
}


