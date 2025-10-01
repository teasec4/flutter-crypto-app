import 'package:hive/hive.dart';

part 'coin.g.dart';

@HiveType(typeId: 0)
class Coin extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String symbol;

  @HiveField(3)
  double price;

  @HiveField(4)
  String imageUrl;

  @HiveField(5) // ✅ новое поле
  double marketCap;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.imageUrl,
    required this.marketCap,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      price: (json['current_price'] as num).toDouble(),
      imageUrl: json['image'] as String,
      marketCap: (json['market_cap'] as num).toDouble(), // ✅ CoinGecko API
    );
  }
}