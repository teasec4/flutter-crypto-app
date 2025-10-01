import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/coin.dart';

class CoinService {
  final Dio _dio = Dio();

  Future<void> fetchAndSaveCoins() async {
    final response = await _dio.get<List<dynamic>>(
      'https://api.coingecko.com/api/v3/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 200,
        'page': 1,
        'sparkline': false,
      },
    );

    if (response.data == null) return;

    final coinsBox = Hive.box<Coin>('coinsBoxV2');
    await coinsBox.clear();

    for (var e in response.data!) {
      final coin = Coin.fromJson(e as Map<String, dynamic>);
      coinsBox.put(coin.id, coin);
    }
  }

  List<Coin> getAllCoins() {
    final coinsBox = Hive.box<Coin>('coinsBoxV2');
    return coinsBox.values.toList();
  }
}