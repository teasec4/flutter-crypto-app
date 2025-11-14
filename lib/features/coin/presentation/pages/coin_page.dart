import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/core/theme/app_palete.dart';
import 'package:routepractice/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:routepractice/features/coin/presentation/widgets/coin_list_widget.dart';
import 'package:routepractice/features/coin/presentation/widgets/empty_view.dart';
import 'package:routepractice/features/coin/presentation/widgets/error_view.dart';
import 'package:routepractice/features/coin/presentation/widgets/scroll_pagination_listener.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_header.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  late ScrollController _scrollController;
  late ScrollPaginationListener _paginationListener;

  @override
  void initState() {
    super.initState();
    _initializeScrollListener();
    context.read<CoinBloc>().add(const CoinInitialLoad());
  }

  void _initializeScrollListener() {
    _scrollController = ScrollController();
    _paginationListener = CoinScrollPaginationListener(
      onLoadMore: () {
        context.read<CoinBloc>().add(const CoinLoadMore());
      },
      isLoadingMore: () {
        final state = context.read<CoinBloc>().state;
        return state is CoinLoaded && state.isLoadingMore;
      },
      threshold: 200,
    );

    _scrollController.addListener(() {
      _paginationListener.onScroll(_scrollController.position);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinBloc, CoinState>(
      builder: (context, state) {
        if (state is CoinLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppPalette.accent),
          );
        }

        if (state is CoinError) {
          return ErrorView(
            error: state.message,
            onRetry: () {
              context.read<CoinBloc>().add(const CoinRefresh());
            },
          );
        }

        if (state is CoinLoaded) {
          // Empty state
          if (state.coins.isEmpty) {
            return const EmptyView();
          }

          // Data state with coin list
          return SafeArea(
            top: true,
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GlobalMarketHeader(),
                const Divider(
                  color: AppPalette.accent,
                  height: 1,
                  indent: 15,
                  endIndent: 15,
                ),
                Expanded(
                  child: CoinListWidget(
                    coins: state.coins,
                    isLoadingMore: state.isLoadingMore,
                    scrollController: _scrollController,
                    onRefresh: () async {
                      context.read<CoinBloc>().add(const CoinRefresh());
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
