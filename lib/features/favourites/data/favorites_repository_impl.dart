import 'package:cookmate/core/models/recipe.dart';
import 'package:cookmate/core/services/local_storage/favorites_service.dart';

import '../domain/favorites_repository.dart';


class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesService _favoritesService;

  FavoritesRepositoryImpl(this._favoritesService);

  @override
  List<Recipe> fetchAllFavorites() {
    return _favoritesService.getAllFavorites();
  }

  @override
  Future<void> removeFavorite(int recipeId) {
    return _favoritesService.removeFavorite(recipeId);
  }

  @override
  Future<void> addFavorite(Recipe recipe) {
    return _favoritesService.addFavorite(recipe);
  }

}