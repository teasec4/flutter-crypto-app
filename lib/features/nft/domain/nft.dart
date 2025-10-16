class NFT {
  final String id;
  final String contractAddress;
  final String name;
  final String assetPlatformId;
  final String symbol;
  final String? imageUrl;
  final double? floorPrice;
  final String? floorPriceCurrency;
  final double? marketCap;
  final double? volume24h;
  final double? priceChange24h;

  const NFT({
    required this.id,
    required this.contractAddress,
    required this.name,
    required this.assetPlatformId,
    required this.symbol,
    this.imageUrl,
    this.floorPrice,
    this.floorPriceCurrency,
    this.marketCap,
    this.volume24h,
    this.priceChange24h,
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      id: json['id'] as String,
      contractAddress: json['contract_address'] as String,
      name: json['name'] as String,
      assetPlatformId: json['asset_platform_id'] as String,
      symbol: json['symbol'] as String,
      imageUrl: json['image'] as String?,
      floorPrice: (json['floor_price'] as num?)?.toDouble(),
      floorPriceCurrency: json['floor_price_currency'] as String?,
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      volume24h: (json['volume_24h'] as num?)?.toDouble(),
      priceChange24h: (json['floor_price_in_usd_24h_percentage_change'] as num?)?.toDouble(),
    );
  }

  factory NFT.fromOpenSeaJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};

    return NFT(
      id: json['slug'] as String? ?? json['name'].toString().toLowerCase().replaceAll(' ', '-'),
      contractAddress: '', // OpenSea doesn't provide this in collections list
      name: json['name'] as String? ?? 'Unknown Collection',
      assetPlatformId: 'ethereum', // Default to Ethereum
      symbol: json['slug'] as String? ?? 'unknown',
      imageUrl: json['image_url'] as String?,
      floorPrice: (stats['floor_price'] as num?)?.toDouble(),
      floorPriceCurrency: 'ETH', // OpenSea prices are in ETH
      marketCap: (stats['market_cap'] as num?)?.toDouble(),
      volume24h: (stats['one_day_volume'] as num?)?.toDouble(),
      priceChange24h: (stats['one_day_change'] as num?)?.toDouble(),
    );
  }



  factory NFT.fromReservoirJson(Map<String, dynamic> json) {
    final floorAsk = json['floorAsk'] as Map<String, dynamic>?;
    final floorPrice = floorAsk?['price']?['amount']?['decimal'] as num?;
    final usdPrice = floorAsk?['price']?['amount']?['usd'] as num?;
    final volume1Day = (json['volume'] as Map<String, dynamic>?)?['1day'] as num?;

    // Use slug for routing, fallback to id
    final slug = json['slug'] as String?;
    final id = json['id'] as String?;

    return NFT(
      id: slug ?? id ?? 'unknown', // Prefer slug for routing
      contractAddress: id ?? '', // Keep contract address separate
      name: json['name'] as String? ?? 'Unknown Collection',
      assetPlatformId: json['chain'] as String? ?? 'ethereum',
      symbol: slug ?? 'unknown',
      imageUrl: json['image'] as String?,
      floorPrice: floorPrice?.toDouble(),
      floorPriceCurrency: usdPrice != null ? 'USD' : 'ETH',
      marketCap: null, // Reservoir doesn't provide market cap directly
      volume24h: volume1Day?.toDouble(),
      priceChange24h: null, // Reservoir doesn't provide change percentage
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract_address': contractAddress,
      'name': name,
      'asset_platform_id': assetPlatformId,
      'symbol': symbol,
      'image': imageUrl,
      'floor_price': floorPrice,
      'floor_price_currency': floorPriceCurrency,
      'market_cap': marketCap,
      'volume_24h': volume24h,
      'floor_price_in_usd_24h_percentage_change': priceChange24h,
    };
  }

  @override
  String toString() {
    return 'NFT(id: $id, name: $name, symbol: $symbol, floorPrice: $floorPrice $floorPriceCurrency)';
  }
}
