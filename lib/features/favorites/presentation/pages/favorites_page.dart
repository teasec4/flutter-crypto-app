import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/favorites/domain/favorite_item.dart';
import 'package:routepractice/features/favorites/presentation/favorites_view_model.dart';
import 'package:routepractice/features/favorites/presentation/widgets/favorite_item_widget.dart';

enum FavoriteViewType { coins, nfts }

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  FavoriteViewType _selectedView = FavoriteViewType.coins;

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesNotifierProvider);

    return SafeArea(
      child: Column(
        children: [
          // Toggle between Coins and NFTs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppPalette.surface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      'Coins',
                      _selectedView == FavoriteViewType.coins,
                      () => setState(() => _selectedView = FavoriteViewType.coins),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      'NFTs',
                      _selectedView == FavoriteViewType.nfts,
                      () => setState(() => _selectedView = FavoriteViewType.nfts),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Favorites List
          Expanded(
            child: favoritesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error', style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(favoritesNotifierProvider.notifier).loadFavorites(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (favorites) {
                final filteredFavorites = favorites.where((favorite) {
                  return _selectedView == FavoriteViewType.coins
                      ? favorite.type == FavoriteType.coin
                      : favorite.type == FavoriteType.nft;
                }).toList();

                if (filteredFavorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ${_selectedView == FavoriteViewType.coins ? 'coins' : 'NFTs'} in favorites yet ❤️',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Swipe left on items to add them here!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredFavorites.length,
                  itemBuilder: (context, index) {
                    final favorite = filteredFavorites[index];
                    return FavoriteItemWidget(
                      favorite: favorite,
                      onRemove: () => _removeFavorite(favorite),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _removeFavorite(FavoriteItem favorite) {
    ref.read(favoritesNotifierProvider.notifier).removeFavorite(favorite.id, favorite.type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${favorite.name} removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
