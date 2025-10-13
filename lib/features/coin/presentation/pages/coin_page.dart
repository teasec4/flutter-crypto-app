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
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref.read(coinNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final coinsAsync = ref.watch(coinNotifierProvider);

    return Scaffold(
      body: coinsAsync.when(
        data: (coins) => RefreshIndicator(
          onRefresh: () =>
              ref.read(coinNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            controller: scrollController,
            itemCount: coins.length + 1,
            itemBuilder: (_, i) {
              if (i == coins.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return CoinTile(coin: coins[i]);
            },
          ),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}