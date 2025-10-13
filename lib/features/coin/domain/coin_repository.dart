
import 'package:routepractice/features/coin/domain/coin.dart';

abstract interface class CoinRepository {
  Future<List<Coin>> getCoins({int page = 1, int perPage = 50});
}