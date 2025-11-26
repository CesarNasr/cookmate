import 'package:cookmate/features/favourites/favorites_screen.dart';
import 'package:cookmate/features/generate_recipe/presentation/recipe_finder/recipe_finder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/ingredients/ingredients_screen.dart';
import '../providers/navigation_provider.dart';

class MainNavigationScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,});


  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final selectedIndex = ref.watch(selectedIndexProvider);

    // List of screens
    final screens = [
      const IngredientsScreen(),
      const RecipeFinderScreen(),
      const FavoritesScreen(),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        /*currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).setIndex(index);
        },*/
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Ingredients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Recipe Finder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}