import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/coin/presentation/coin_view_model.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_header.dart';

class CoinPage extends ConsumerStatefulWidget {
  const CoinPage({super.key});

  @override
  ConsumerState<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends ConsumerState<CoinPage> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final notifier = ref.read(coinNotifierProvider.notifier);

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !notifier.isLoadingMore) {
        notifier.loadMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🔥 build() called');
    final coinsAsync = ref.watch(coinNotifierProvider);
    final notifier = ref.read(coinNotifierProvider.notifier);

    ref.listen(coinNotifierProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ $err'),
              backgroundColor: AppPalette.accent,
            ),
          );
        },
      );
    });

    return  coinsAsync.when(
        data: (coins) {
          // Пустой список
          if (coins.isEmpty) {
            return const Center(
              child: Text(
                "😕 No coins found",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GlobalMarketHeader(),
                const Divider(color: AppPalette.accent, height: 1, indent: 15, endIndent: 15,),
                Expanded(
                  child: RefreshIndicator(
                    color: AppPalette.accent,
                    backgroundColor: AppPalette.background,
                    onRefresh: () => notifier.refresh(),
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: coins.length + 1,
                      itemBuilder: (context, i) {

                        if (i == coins.length) {
                          return notifier.isLoadingMore
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


                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 250 + (i % 10) * 20),
                          opacity: 1,
                          child: AnimatedSlide(
                            offset: const Offset(0, 0.1),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            child: CoinTile(coin: coins[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await notifier.refresh(); // запускает повторную загрузку
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppPalette.accent),
        ),
      );

  }
}