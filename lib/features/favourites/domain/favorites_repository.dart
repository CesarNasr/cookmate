
import 'package:cookmate/core/models/recipe.dart';


abstract class FavoritesRepository {
  List<Recipe> fetchAllFavorites();
  Future<void> removeFavorite(int recipeId);
  Future<void> addFavorite(Recipe recipe);
}


