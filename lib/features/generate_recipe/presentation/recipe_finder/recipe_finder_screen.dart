import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/models/recipe.dart';
import '../../../../providers/recipe_finder_viewmodel_provider.dart';

class RecipeFinderScreen extends ConsumerStatefulWidget {
  const RecipeFinderScreen({super.key});

  @override
  ConsumerState<RecipeFinderScreen> createState() => _RecipeFinderScreenState();
}

class _RecipeFinderScreenState extends ConsumerState<RecipeFinderScreen> {
  late TextEditingController ingredientsController;
  List<String> selectedIngredients = [];

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

  void addIngredient() {
    // Remove comma and trim whitespace
    final ingredient = ingredientsController.text.replaceAll(',', '').trim();
    if (ingredient.isNotEmpty && !selectedIngredients.contains(ingredient)) {
      setState(() {
        selectedIngredients.add(ingredient);
        ingredientsController.clear();
      });
    }
  }

  void removeIngredient(String ingredient) {
    setState(() {
      selectedIngredients.remove(ingredient);
    });
  }

  void clearAllIngredients() {
    setState(() {
      selectedIngredients.clear();
    });
  }

  Future<void> findRecipes() async {
    if (selectedIngredients.isEmpty) return;

    final ingredients = selectedIngredients.join(', ');

    // Fetch recipes
    await ref.read(recipeFinderViewModelProvider.notifier).fetchRecipes(ingredients);

    // Check the result after fetch completes
    if (mounted) {
      final recipeState = ref.read(recipeFinderViewModelProvider);

      recipeState.when(
        data: (container) {
          // Navigate with the data if successful
          context.push(RECIPE_LIST_SCREEN_ROUTE, extra: container);
        },
        error: (error, stack) {
          // Show error in SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {
          // This shouldn't happen as we wait for the future to complete
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeFinderViewModelProvider);
    final isLoading = recipeState.isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's in your fridge?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Ingredients Label
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Input Field
              TextField(
                controller: ingredientsController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'e.g., chicken breast, tomatoes, rice',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: isLoading ? null : () {
                      // Voice input functionality can be added here
                    },
                  ),
                ),
                onSubmitted: (_) => isLoading ? null : addIngredient(),
                onChanged: (value) {
                  if (value.endsWith(',') && !isLoading) {
                    addIngredient();
                  }
                },
              ),
              const SizedBox(height: 24),

              // Your Ingredients Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Ingredients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (selectedIngredients.isNotEmpty && !isLoading)
                    TextButton(
                      onPressed: clearAllIngredients,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Selected Ingredients Chips
              Expanded(
                child: selectedIngredients.isEmpty
                    ? Center(
                  child: Text(
                    'No ingredients added yet',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                    : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedIngredients.map((ingredient) {
                    return Chip(
                      label: Text(
                        ingredient,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.green[50],
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: isLoading ? null : () => removeIngredient(ingredient),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Find Recipes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (selectedIngredients.isEmpty || isLoading) ? null : findRecipes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Find Recipes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}