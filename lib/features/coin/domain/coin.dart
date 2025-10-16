class Coin{
  final String id;
  final String name;
  final String symbol;
  final double price;
  final String imageUrl;
  final String marketCap;
  final double priceChange24H;
  final double priceChangePercentage24H;

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.imageUrl,
    required this.marketCap,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      marketCap: json['marketCap'] as String,
      priceChange24H: (json['priceChange24H'] as num).toDouble(),
      priceChangePercentage24H: (json['priceChangePercentage24H'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'price': price,
      'imageUrl': imageUrl,
      'marketCap': marketCap,
      'priceChange24H': priceChange24H,
      'priceChangePercentage24H': priceChangePercentage24H,
    };
  }
}


