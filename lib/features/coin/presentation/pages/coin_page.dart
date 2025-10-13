import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/coin/presentation/coin_view_model.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_tile.dart';

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
    final coinsAsync = ref.watch(coinNotifierProvider);
    final notifier = ref.read(coinNotifierProvider.notifier);

    ref.listen(coinNotifierProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ $err'),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: coinsAsync.when(
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

          return RefreshIndicator(
            color: Colors.yellowAccent,
            backgroundColor: Colors.black,
            onRefresh: () => notifier.refresh(),
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: coins.length + 1,
              itemBuilder: (context, i) {
                // Индикатор загрузки внизу
                if (i == coins.length) {
                  return notifier.isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                // Анимация появления монет
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
          );
        },
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.yellow),
        ),
      ),
    );
  }
}