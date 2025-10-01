import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/coin_service.dart';
import '../models/coin.dart';

final coinServiceProvider = Provider((ref) => CoinService());

final coinsProvider = FutureProvider<List<Coin>>((ref) async {
  final service = ref.read(coinServiceProvider);
  await service.fetchAndSaveCoins();
  return service.getAllCoins();
});