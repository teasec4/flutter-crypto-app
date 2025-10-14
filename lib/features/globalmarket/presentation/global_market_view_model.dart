
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:routepractice/features/globalmarket/data/global_market_service.dart';
import 'package:routepractice/features/globalmarket/domain/coin_market.dart';
import 'package:routepractice/features/globalmarket/domain/global_market_repository.dart';

final globalMarketRepositoryProvider = Provider<GlobalMarketRepository>((ref){
  return GlobalMarketService();
});

final globalMarketViewModelProvider = StateNotifierProvider<GlobalMarketViewModel, AsyncValue<GlobalMarketData>>(
    (ref){
      final repo = ref.watch(globalMarketRepositoryProvider);
      final vm = GlobalMarketViewModel(repo);
      vm.loadData();
      return vm;
    }
);

class GlobalMarketViewModel extends StateNotifier<AsyncValue<GlobalMarketData>> {
  final GlobalMarketRepository _repo;
  GlobalMarketViewModel(this._repo) : super(const AsyncLoading());

  Future<void> loadData() async {
    print('🌐 GlobalMarketViewModel.loadData() START');
    try {
      state = const AsyncLoading();
      final data = await _repo.getGlobalMarketData();
      print('✅ Global data fetched successfully!');
      state = AsyncData(data);
    } catch (e, st) {
      print('❌ GlobalMarketViewModel error: $e');
      state = AsyncError(e, st);
    }
  }
}