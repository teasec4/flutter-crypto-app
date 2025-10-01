import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../viewmodels/coin_view_model.dart';
import '../viewmodels/user_view_model.dart';
import '../viewmodels/search_query_provider.dart';
import '../widgets/row_coin_view.dart';

class CoinListView extends ConsumerStatefulWidget {
  const CoinListView({super.key});

  @override
  ConsumerState<CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends ConsumerState<CoinListView> {
  late final TextEditingController _controller;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(searchQueryProvider);
    _controller = TextEditingController(text: initial);
    _listener = () {
      final v = _controller.text;
      if (ref.read(searchQueryProvider) != v) {
        ref.read(searchQueryProvider.notifier).set(v);
      }
    };
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinsAsync = ref.watch(coinsProvider);
    final user = ref.watch(userProvider).value;
    final query = ref.watch(searchQueryProvider).toLowerCase();

    return Column(
      children: [
        // 🔍 поиск
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search coins...",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
            ),
          ),
        ),

        Expanded(
          child: Stack(
            children: [
              coinsAsync.when(
                data: (coins) {
                  // 🔎 фильтрация
                  var filtered = coins.where((c) {
                    return c.name.toLowerCase().contains(query) ||
                        c.symbol.toLowerCase().contains(query);
                  }).toList();

                  // 📊 сортировка по умолчанию — marketCap
                  filtered.sort((a, b) => b.marketCap.compareTo(a.marketCap));

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(coinsProvider),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final coin = filtered[index];
                        final isFav =
                            user?.favoriteIds.contains(coin.id) ?? false;

                        return Slidable(
                          key: ValueKey(coin.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  ref
                                      .read(userProvider.notifier)
                                      .toggleFavorite(coin.id);
                                },
                                backgroundColor:
                                    isFav ? Colors.red : Colors.green,
                                foregroundColor: Colors.white,
                                icon: isFav ? Icons.star_border : Icons.star,
                                label: isFav ? "Remove" : "Add",
                              ),
                            ],
                          ),
                          child: RowCoinView(
                            coin: coin,
                            isFavorite: isFav,
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text("Error: $err")),
              ),

              if (coinsAsync.isRefreshing)
                const Positioned(
                  top: 0, left: 0, right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          ),
        ),
      ],
    );
  }
}