import 'package:routepractice/features/coin/domain/coin.dart';
import 'package:routepractice/features/nft/domain/nft.dart';

enum FavoriteType {
  coin,
  nft,
}

class FavoriteItem {
  final String id;
  final FavoriteType type;
  final String name;
  final String symbol;
  final String? imageUrl;
  final Map<String, dynamic> data;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.name,
    required this.symbol,
    this.imageUrl,
    required this.data,
  });

  factory FavoriteItem.fromCoin(Coin coin) {
    return FavoriteItem(
      id: coin.id,
      type: FavoriteType.coin,
      name: coin.name,
      symbol: coin.symbol,
      imageUrl: coin.imageUrl,
      data: coin.toJson(),
    );
  }

  factory FavoriteItem.fromNFT(NFT nft) {
    return FavoriteItem(
      id: nft.contractAddress.isNotEmpty ? nft.contractAddress : nft.id,
      type: FavoriteType.nft,
      name: nft.name,
      symbol: nft.symbol,
      imageUrl: nft.imageUrl,
      data: nft.toJson(),
    );
  }

  Coin toCoin() {
    if (type != FavoriteType.coin) throw Exception('Not a coin favorite');
    return Coin.fromJson(data);
  }

  NFT toNFT() {
    if (type != FavoriteType.nft) throw Exception('Not an NFT favorite');
    return NFT.fromJson(data);
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      type: FavoriteType.values[json['type'] as int],
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      imageUrl: json['imageUrl'] as String?,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'name': name,
      'symbol': symbol,
      'imageUrl': imageUrl,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'FavoriteItem(id: $id, type: $type, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
