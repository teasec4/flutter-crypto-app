import 'package:routepractice/features/coin/domain/coin.dart';

class CoinMapper {
  static Coin fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '',
      price: (json['current_price'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? '',
      marketCap: json['market_cap_rank']?.toString() ?? 'N/A',
      priceChange24H: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24H:
          (json['price_change_percentage_24h'] ?? 0).toDouble(),
    );
  }

  static Coin fromDetailJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '',
      price: (json['market_data']?['current_price']?['usd'] ?? 0).toDouble(),
      imageUrl: json['image']?['large'] ?? json['image']?['small'] ?? '',
      marketCap: json['market_data']?['market_cap_rank']?.toString() ?? 'N/A',
      priceChange24H:
          (json['market_data']?['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24H:
          (json['market_data']?['price_change_percentage_24h'] ?? 0)
              .toDouble(),
    );
  }
}
