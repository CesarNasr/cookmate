import 'dart:async';

import '../../../core/models/Recipe.dart';
import '../../../core/models/RecipeListContainer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/RecipeRepositoryImpl.dart';
import '../domain/RecipeRepository.dart';

final recipeFinderViewModelProvider = AsyncNotifierProvider<RecipeFinderViewModel, RecipeListContainer>(RecipeFinderViewModel.new);

class RecipeFinderViewModel extends AsyncNotifier<RecipeListContainer> {

  late final RecipeRepository _repository;

  @override
  Future<RecipeListContainer> build() async {
    _repository = ref.read(recipesRepositoryProvider);

    return RecipeListContainer(recipes: const []);
  }

  Future<void> fetchRecipes(String input) async {
    state = const AsyncValue.loading();

    try {
      final ingredients = input
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final container = await _repository.fetchRecipes(ingredients);

      state = AsyncValue.data(container);

    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}




/* todo use later : state management
class RecipeState {
  final List<Recipe> recipes;
  final bool isLoading;
  final String? errorMessage;

  RecipeState({
    this.recipes = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  RecipeState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}*/
