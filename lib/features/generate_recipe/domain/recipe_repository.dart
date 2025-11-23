
import 'package:cookmate/core/utils/resource.dart';

import '../../../core/models/recipe_list_container.dart';


abstract class RecipeRepository {
  Future<Resource<RecipeListContainer>> fetchRecipes(List<String> ingredients);
}


