import 'package:hive_ce/hive.dart';
import '../../models/recipe.dart';

class FavoritesService {
  static const String _boxName = 'favorites';

  // Get the favorites box
  Box get _box => Hive.box(_boxName);

  // Add recipe to favorites using recipe ID as key
  Future<void> addFavorite(Recipe recipe) async {
    await _box.put(recipe.id, recipe.toJson());
  }

  // Remove recipe from favorites by ID
  Future<void> removeFavorite(int recipeId) async {
    await _box.delete(recipeId);
  }

  // Toggle favorite status (add if not exists, remove if exists)
  Future<void> toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) {
      await removeFavorite(recipe.id);
    } else {
      await addFavorite(recipe);
    }
  }

  // Check if a recipe is in favorites by ID
  bool isFavorite(int recipeId) {
    return _box.containsKey(recipeId);
  }

  // Get all favorite recipes
  List<Recipe> getAllFavorites() {
    try {
      return _box.values.map((json) {
        // Deep convert all nested maps to Map<String, dynamic>
        final map = _convertToStringMap(json);
        return Recipe.fromJson(map);
      }).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  // Helper method to recursively convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _convertToStringMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries.map((entry) {
          final key = entry.key.toString();
          final val = entry.value;

          if (val is Map) {
            return MapEntry(key, _convertToStringMap(val));
          } else if (val is List) {
            return MapEntry(key, _convertList(val));
          } else {
            return MapEntry(key, val);
          }
        }),
      );
    }
    return {};
  }

  // Helper method to convert lists
  List<dynamic> _convertList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map) {
        return _convertToStringMap(item);
      } else if (item is List) {
        return _convertList(item);
      } else {
        return item;
      }
    }).toList();
  }

  // Get favorites count
  int getFavoritesCount() {
    return _box.length;
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _box.clear();
  }

  // Get a specific favorite recipe by ID
  Recipe? getFavorite(String recipeId) {
    try {
      final json = _box.get(recipeId);
      if (json == null) return null;

      // Deep convert to Map<String, dynamic>
      final map = _convertToStringMap(json);
      return Recipe.fromJson(map);
    } catch (e) {
      print('Error getting favorite: $e');
      return null;
    }
  }

  // Get all favorite recipe IDs
  List<String> getAllFavoriteIds() {
    try {
      return _box.values.map((json) {
        final map = _convertToStringMap(json);
        return map['id'] as String;
      }).toList();
    } catch (e) {
      print('Error getting favorite IDs: $e');
      return [];
    }
  }
}