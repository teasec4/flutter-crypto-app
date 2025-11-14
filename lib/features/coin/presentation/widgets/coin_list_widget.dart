import 'package:flutter/material.dart';
import 'package:routepractice/core/theme/app_palette.dart';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';

class CoinListWidget extends StatelessWidget {
  final List<Coin> coins;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const CoinListWidget({
    required this.coins,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppPalette.accent,
      backgroundColor: AppPalette.background,
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: coins.length + 1,
        itemBuilder: (context, index) {
          // Loading indicator at the end
          if (index == coins.length) {
            return isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.accent,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          return CoinTile(coin: coins[index]);
        },
      ),
    );
  }
}
