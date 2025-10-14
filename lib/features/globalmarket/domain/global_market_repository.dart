
import 'package:routepractice/features/globalmarket/domain/coin_market.dart';

abstract interface class GlobalMarketRepository{
  Future<GlobalMarketData> getGlobalMarketData();
}