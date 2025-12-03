import 'package:cookmate/features/favourites/domain/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_storage/favorites_service.dart';
import '../features/favourites/data/favorites_repository_impl.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final favoritesService = FavoritesService();

  // Passing the service to the constructor
  return FavoritesRepositoryImpl(favoritesService);
});