import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/Recipe.dart';
import 'GenerateRecipeViewModel.dart';
import 'RecipeCard.dart';

class RecipeFinderScreen extends ConsumerStatefulWidget {
  const RecipeFinderScreen({super.key});

  @override
  ConsumerState<RecipeFinderScreen> createState() => _RecipeFinderScreenState();
}

class _RecipeFinderScreenState extends ConsumerState<RecipeFinderScreen> {
  late TextEditingController ingredientsController;

  @override
  void initState() {
    super.initState();
    ingredientsController = TextEditingController();
  }

  @override
  void dispose() {
    ingredientsController.dispose();
    super.dispose();
  }

  void findRecipes() {
    final rawInput = ingredientsController.text.trim();
    if (rawInput.isEmpty) return;

    ref.read(recipeViewModelProvider.notifier).fetchRecipes(rawInput);
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsyncValue = ref.watch(recipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍🍳 CookMate Finder'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (e.g., tomato, cheese, pasta)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: findRecipes,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => findRecipes(), // ← FIXED
            ),

            const SizedBox(height: 16),

            Expanded(
              child: recipeAsyncValue.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                ),

                error: (e, st) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      '❌ Error Fetching Recipes:\n${e.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                data: (container) {
                  final recipes = container.recipes;

                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recipes found. Try entering some ingredients!",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(recipe: recipe);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}