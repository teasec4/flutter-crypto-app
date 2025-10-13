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
}


