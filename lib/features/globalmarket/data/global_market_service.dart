import 'dart:async';
import 'dart:convert';
import 'package:routepractice/features/globalmarket/domain/coin_market.dart';
import 'package:routepractice/features/globalmarket/domain/global_market_repository.dart';
import 'package:http/http.dart' as http;

class GlobalMarketService implements GlobalMarketRepository {
  @override
  Future<GlobalMarketData> getGlobalMarketData() async {
    final url = Uri.parse("https://api.coingecko.com/api/v3/global");

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('❌ Failed to fetch global data');
      }

      final Map<String, dynamic> json = jsonDecode(response.body);
      final data = json['data'] as Map<String, dynamic>;

      return GlobalMarketData(
        totalMarketCap: Map<String, double>.from(
          data['total_market_cap'].map(
                (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
        ),
        totalVolume: Map<String, double>.from(
          data['total_volume'].map(
                (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
        ),
        marketCapChangePercentage24hUsd:
        (data['market_cap_change_percentage_24h_usd'] as num).toDouble(),
      );
    } on TimeoutException {
      throw Exception('⏰ Request timed out. Check your internet connection.');
    } catch (e) {
      throw Exception('❌ Unexpected error: $e');
    }
  }
}