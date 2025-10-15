
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_view_model.dart';

class GlobalMarketHeader extends ConsumerWidget{
  const GlobalMarketHeader({super.key});

  String _formatNumber(double num){
    if (num >= 1_000_000_000_000) return "${(num / 1e12).toStringAsFixed(2)}T";
    if (num >= 1_000_000_000) return "${(num / 1e9).toStringAsFixed(2)}B";
    if (num >= 1_000_000) return "${(num / 1e6).toStringAsFixed(2)}M";
    return num.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalMarketViewModelProvider);

    return state.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Global Market Cap:' , style: TextStyle(color: Colors.white70, fontSize: 12),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${_formatNumber(data.totalMarketCap['usd'] ?? 0)}', style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(width: 8,),
                        Text('${data.marketCapChangePercentage24hUsd.toStringAsFixed(2)}%',
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
          ),
        ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error: $e", style: const TextStyle(color: Colors.red)),
    );
  }
}