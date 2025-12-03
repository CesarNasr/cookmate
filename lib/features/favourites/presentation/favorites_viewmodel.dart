import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recipe.dart';
import '../../../core/utils/resource.dart';
import '../../../providers/favorites_repository_provider.dart';

class FavoritesViewmodel extends AsyncNotifier<List<Recipe>> {
  late final _favoritesRepository;

  @override
  FutureOr<List<Recipe>> build() {
    _favoritesRepository = ref.read(favoritesRepositoryProvider);
    return List.empty();
  }

  // Fetch all favorites from repository
  void fetchFavorites() async {
    try {
      state = const AsyncValue.loading();
      final result = await _favoritesRepository.fetchAllFavorites();
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Remove recipe from favorites
  void removeFromFavorites(int recipeId) async {
    try {
      // Optimistically update UI by removing from current state


      // Call repository to remove
      final result = await _favoritesRepository.removeFavorite(recipeId);

      // Handle result if needed
      switch (result) {
        case Success():
          state.whenData((recipes) {
            state = AsyncValue.data(
              recipes.where((recipe) => recipe.id != recipeId).toList(),
            );
          });

        // Successfully removed, UI already updated optimistically
          break;
        case Error():
        // If failed, refresh to get correct state
          fetchFavorites();
          break;
        case Loading():
          break;
      }
    } catch (e, stack) {
      // On error, refresh to get correct state
      fetchFavorites();
    }
  }

  // Add recipe to favorites (if needed)
  void addToFavorites(Recipe recipe) async {
    try {
      // Optimistically add to UI
      state.whenData((recipes) {
        state = AsyncValue.data([...recipes, recipe]);
      });

      final result = await _favoritesRepository.addFavorite(recipe);

      switch (result) {
        case Success():
        // Successfully added
          break;
        case Error():
        // If failed, refresh to get correct state
          fetchFavorites();
          break;
        case Loading():
          break;
      }
    } catch (e, stack) {
      fetchFavorites();
    }
  }

  // Check if a recipe is in favorites
  bool isFavorite(String recipeId) {
    return state.maybeWhen(
      data: (recipes) => recipes.any((recipe) => recipe.id == recipeId),
      orElse: () => false,
    );
  }

  // Get favorites count
  int getFavoritesCount() {
    return state.maybeWhen(
      data: (recipes) => recipes.length,
      orElse: () => 0,
    );
  }
}
