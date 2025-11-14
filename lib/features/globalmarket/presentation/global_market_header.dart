import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_bloc.dart';

class GlobalMarketHeader extends StatefulWidget {
  const GlobalMarketHeader({super.key});

  @override
  State<GlobalMarketHeader> createState() => _GlobalMarketHeaderState();
}

class _GlobalMarketHeaderState extends State<GlobalMarketHeader> {
  @override
  void initState() {
    super.initState();
    context.read<GlobalMarketBloc>().add(const GlobalMarketLoadData());
  }

  String _formatNumber(double num) {
    if (num >= 1_000_000_000_000) return "${(num / 1e12).toStringAsFixed(2)}T";
    if (num >= 1_000_000_000) return "${(num / 1e9).toStringAsFixed(2)}B";
    if (num >= 1_000_000) return "${(num / 1e6).toStringAsFixed(2)}M";
    return num.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalMarketBloc, GlobalMarketState>(
      builder: (context, state) {
        if (state is GlobalMarketLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GlobalMarketError) {
          return Text(
            "Error: ${state.message}",
            style: const TextStyle(color: Colors.red),
          );
        }

        if (state is GlobalMarketLoaded) {
          final data = state.data;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Global Market Cap:',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${_formatNumber(data.totalMarketCap['usd'] ?? 0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${data.marketCapChangePercentage24hUsd.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: data.marketCapChangePercentage24hUsd >= 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '24h Volume:',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '\$${_formatNumber(data.totalVolume['usd'] ?? 0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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