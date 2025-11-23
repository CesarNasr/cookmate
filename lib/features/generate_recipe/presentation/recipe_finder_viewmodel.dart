import 'dart:async';
import '../../../core/models/recipe_list_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/resource.dart';
import '../../../providers/recipe_repository_provider.dart';
import '../domain/recipe_repository.dart';


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

      final result = await _repository.fetchRecipes(ingredients);

      // Convert Resource to AsyncValue
      switch (result) {
        case Success(:final data):
          state = AsyncValue.data(data);

        case Error(:final message, :final code, :final status):
        // Create a custom exception with more details
          final errorMessage = code != null ? '[$code] $message' : message;
          state = AsyncValue.error(
            Exception(errorMessage),
            StackTrace.current,
          );

        case Loading():
        // This shouldn't happen in repository, but handle it
          state = const AsyncValue.loading();
      }
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
