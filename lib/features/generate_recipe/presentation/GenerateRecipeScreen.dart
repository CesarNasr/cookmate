import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/Recipe.dart';
import 'GenerateRecipeViewModel.dart';



class RecipeFinderScreen extends ConsumerStatefulWidget {
  const RecipeFinderScreen({super.key});

  @override
  ConsumerState<RecipeFinderScreen> createState() => _RecipeFinderScreenState();
}

class _RecipeFinderScreenState extends ConsumerState<RecipeFinderScreen> {
  final TextEditingController _ingredientsController = TextEditingController();

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  // Function to parse the input and trigger the API call
  void _findRecipes() {
    // Trim input and split by comma, filter out empty strings
    final rawInput = _ingredientsController.text.trim();
    if (rawInput.isEmpty) return;

    final ingredients = rawInput
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (ingredients.isNotEmpty) {
      // Call the fetch method on the ViewModel
      ref.read(recipeViewModelProvider.notifier).fetchRecipes(ingredients);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch the state, which is AsyncValue<RecipeListContainer>
    final recipeAsyncValue = ref.watch(recipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍🍳 Gemini Recipe Finder'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Input Section ---
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (e.g., tomato, cheese, pasta)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _findRecipes,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _findRecipes(), // Allows pressing Enter/Done
            ),
            const SizedBox(height: 16),

            // --- Output Section (Handles AsyncValue States) ---
            Expanded(
              child: recipeAsyncValue.when(
                // 1. Loading State
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),

                // 2. Error State
                error: (e, st) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      '❌ Error Fetching Recipes:\n${e.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),

                // 3. Data State
                data: (container) {
                  final recipes = container.recipes;

                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recipes found. Try entering some ingredients!",
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
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

// --- Custom Widget for Recipe Display ---
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),

            // Details Row
            Wrap(
              // 1. Spacing provides horizontal gap between chips
              spacing: 8.0,
              // 2. runSpacing provides vertical gap between rows of chips
              runSpacing: 4.0,
              children: [
                // SizedBoxes are removed, as spacing handles the gaps
                Chip(label: Text(recipe.level), backgroundColor: Colors.amber[100]),
                Chip(label: Text(recipe.duration), backgroundColor: Colors.blue[100]),

                // Displaying labels
                ...recipe.descriptionLabels.take(2).map((label) => Chip(
                  label: Text(label),
                  backgroundColor: Colors.grey[200],
                )),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            // Displaying ingredients list
            ...recipe.ingredients.map((ing) => Text('• ${ing.detail}')).toList(),
          ],
        ),
      ),
    );
  }
}