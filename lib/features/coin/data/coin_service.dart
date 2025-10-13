

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

    final response = await http.get(url);

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
        marketCap: json['market_cap'].toString(),
        priceChange24H: (json['price_change_24h'] ?? 0).toDouble(),
        priceChangePercentage24H:
            (json['price_change_percentage_24h'] ?? 0).toDouble(),
      );
    }).toList();
  }

}