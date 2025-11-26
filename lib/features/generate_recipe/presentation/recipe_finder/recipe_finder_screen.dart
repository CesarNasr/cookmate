import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';

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

  void findRecipes() {
    if (selectedIngredients.isEmpty) return;

    final ingredients = selectedIngredients.join(', ');
    // Navigate to recipe list screen with ingredients
    context.push(RECIPE_LIST_SCREEN_ROUTE, extra: ingredients);
  }

  @override
  Widget build(BuildContext context) {
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: () {
                      // Voice input functionality can be added here
                    },
                  ),
                ),
                onSubmitted: (_) => addIngredient(),
                onChanged: (value) {
                  if (value.endsWith(',')) {
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
                  if (selectedIngredients.isNotEmpty)
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
                      onDeleted: () => removeIngredient(ingredient),
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
                  onPressed: selectedIngredients.isEmpty ? null : findRecipes,
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
                  child: Row(
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