import 'dart:async';
import 'dart:convert';
import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:http/http.dart' as http;
import 'package:routepractice/features/coin/domain/coin_repository.dart';

class CoinService implements CoinRepository{
  @override
  Future<List<Coin>> getCoins({int page =1, int perPage = 50}) async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets'
      '?vs_currency=usd&order=market_cap_desc'
      '&per_page=$perPage&page=$page&sparkline=false',
    );

    try{
      final response = await http
      .get(url)
      .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200){
      throw Exception('Failed to fetch data');
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((json) {
      return Coin(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        price: (json['current_price'] ?? 0).toDouble(),
        imageUrl: json['image'],
        marketCap: json['market_cap_rank'].toString(),
        priceChange24H: (json['price_change_24h'] ?? 0).toDouble(),
        priceChangePercentage24H:
            (json['price_change_percentage_24h'] ?? 0).toDouble(),
      );
    }).toList();
    } on TimeoutException{
      throw Exception('⏰ Request timed out. Check your internet connection.');
    } catch (e){
       throw Exception('❌ Unexpected error: $e');
    }
  }

  @override
  Future<Coin> getCoin(String id) async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/$id');

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch coin data');
      }

      final json = jsonDecode(response.body);

      return Coin(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        price: (json['market_data']['current_price']['usd'] ?? 0).toDouble(),
        imageUrl: json['image']['large'] ?? json['image']['small'] ?? '',
        marketCap: json['market_data']['market_cap_rank'].toString(),
        priceChange24H: (json['market_data']['price_change_24h'] ?? 0).toDouble(),
        priceChangePercentage24H: (json['market_data']['price_change_percentage_24h'] ?? 0).toDouble(),
      );
    } on TimeoutException {
      throw Exception('⏰ Request timed out. Check your internet connection.');
    } catch (e) {
      throw Exception('❌ Unexpected error: $e');
    }
  }

}