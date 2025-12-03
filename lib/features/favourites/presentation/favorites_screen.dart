import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/recipe.dart';
import '../../../providers/favorites_viewmodel_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch favorites when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesViewmodelProvider.notifier).fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesViewmodelProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Saved Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: favoritesState.when(
        data: (recipes) => recipes.isEmpty
            ? _buildEmptyState()
            : _buildFavoritesList(recipes),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildFavoritesList(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _RecipeCard(
          recipe: recipe,
          onLongPress: () => _showDeleteDialog(recipe),
          onTap: () {
            // Navigate to recipe detail
            // Navigator.push(context, MaterialPageRoute(...));
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved recipes yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving your favorite recipes!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFFF7043),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load favorites',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(favoritesViewmodelProvider.notifier).fetchFavorites();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Remove Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${recipe.title}" from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeRecipe(recipe);
            },
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeRecipe(Recipe recipe) async {
    // Remove from favorites
    ref.read(favoritesViewmodelProvider.notifier).removeFromFavorites(recipe.id);

    // Show confirmation snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recipe.title} removed from favorites'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Undo',
            textColor: const Color(0xFFFF7043),
            onPressed: () {
              // Optional: Add undo functionality
            },
          ),
        ),
      );
    }

    // Refresh the list
    ref.read(favoritesViewmodelProvider.notifier).fetchFavorites();
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Recipe Image
              Positioned.fill(
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Heart icon at top-right
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFFF7043),
                    size: 20,
                  ),
                ),
              ),

              // Recipe info at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            recipe.duration,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            ' | ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            recipe.level,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
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