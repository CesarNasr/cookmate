import 'package:cookmate/core/models/ingredient.dart';
import 'package:cookmate/features/favourites/favorites_screen.dart';
import 'package:cookmate/features/generate_recipe/presentation/recipe_finder/recipe_finder_screen.dart';
import 'package:cookmate/features/generate_recipe/presentation/recipe_list/recipe_list_screen.dart';
import 'package:cookmate/features/ingredients/ingredients_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/recipe.dart';
import '../../features/generate_recipe/presentation/recipe_details/recipe_details_screen.dart';
import '../main_navigation_screen.dart';

// Provider for GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/recipe_finder',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ingredients',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: IngredientsScreen(),
                ),
              ),
            ],
          ),
          // Search Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recipe_finder',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RecipeFinderScreen(),
                ),
                  routes: [
                    // Nested route for recipe details
                    GoRoute(
                      path: 'recipe_details',
                      builder: (context, state) {
                        // Get the object from extra
                        final recipe = state.extra as Recipe;
                        return RecipeDetailsScreen(recipe: recipe);
                      },
                    ),

                    GoRoute(
                      path: 'recipe_list',
                      builder: (context, state) {
                        // Get the object from extra
                        final ingredients = state.extra as String;
                        return RecipeListScreen(ingredients: ingredients);
                      },
                    ),
                  ]
              ),
            ],
          ),
          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FavoritesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});



const RECIPE_DETAILS_SCREEN_ROUTE = '/recipe_finder/recipe_details';
const RECIPE_LIST_SCREEN_ROUTE = '/recipe_finder/recipe_list';