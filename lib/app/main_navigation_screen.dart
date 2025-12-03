import 'package:cookmate/features/favourites/presentation/favorites_screen.dart';
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
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screens = [
      const IngredientsScreen(),
      const RecipeFinderScreen(),
      const FavoritesScreen(),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.kitchen_outlined,
                  label: 'Ingredients',
                  index: 0,
                  isSelected: navigationShell.currentIndex == 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.restaurant_menu,
                  label: 'Recipes',
                  index: 1,
                  isSelected: navigationShell.currentIndex == 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.bookmark_border,
                  label: 'Saved',
                  index: 2,
                  isSelected: navigationShell.currentIndex == 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required int index,
        required bool isSelected,
      }) {
    final Color activeColor = const Color(0xFFFF7043); // Orange color
    final Color inactiveColor = Colors.grey.shade400;

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}