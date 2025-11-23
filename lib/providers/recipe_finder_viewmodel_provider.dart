import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/recipe_list_container.dart';
import '../features/generate_recipe/presentation/recipe_finder_viewmodel.dart';

final recipeFinderViewModelProvider = AsyncNotifierProvider<RecipeFinderViewModel, RecipeListContainer>(RecipeFinderViewModel.new);
