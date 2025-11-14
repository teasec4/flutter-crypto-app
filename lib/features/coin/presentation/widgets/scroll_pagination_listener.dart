import 'package:flutter/material.dart';

/// Handles infinite scroll pagination logic
abstract interface class ScrollPaginationListener {
  void onScroll(ScrollPosition position);
}

/// Default implementation for coin list pagination
class CoinScrollPaginationListener implements ScrollPaginationListener {
  final void Function() onLoadMore;
  final bool Function() isLoadingMore;
  final double threshold;

  CoinScrollPaginationListener({
    required this.onLoadMore,
    required this.isLoadingMore,
    this.threshold = 200,
  });

  @override
  void onScroll(ScrollPosition position) {
    if (!isLoadingMore() &&
        position.pixels >= position.maxScrollExtent - threshold) {
      onLoadMore();
    }
  }
}
