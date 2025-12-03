import 'package:cookmate/features/favourites/presentation/favorites_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/recipe.dart';

final favoritesViewmodelProvider = AsyncNotifierProvider<FavoritesViewmodel, List<Recipe>>(FavoritesViewmodel.new);
