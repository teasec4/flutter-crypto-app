import 'package:get_it/get_it.dart';
import 'package:routepractice/core/logger/logger.dart';
import 'package:routepractice/core/utils/retry_strategy.dart';
import 'package:routepractice/features/auth/data/auth_service.dart';
import 'package:routepractice/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:routepractice/features/coin/data/coin_repository_impl.dart';
import 'package:routepractice/features/coin/domain/coin_repository.dart';
import 'package:routepractice/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:routepractice/features/globalmarket/data/global_market_service.dart';
import 'package:routepractice/features/globalmarket/domain/global_market_repository.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core Services
  getIt.registerSingleton<Logger>(ConsoleLogger());
  getIt.registerSingleton<RetryStrategy>(
    ExponentialBackoffRetry(
      maxAttempts: 3,
      initialDelay: const Duration(seconds: 5),
    ),
  );

  // Supabase
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Auth
  getIt.registerSingleton<AuthService>(
    AuthService(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(getIt<AuthService>()),
  );

  // Coin
  getIt.registerSingleton<CoinRepository>(CoinRepositoryImpl());
  getIt.registerSingleton<CoinBloc>(
    CoinBloc(getIt<CoinRepository>(), getIt<RetryStrategy>()),
  );

  // Global Market
  getIt.registerSingleton<GlobalMarketRepository>(GlobalMarketService());
  getIt.registerSingleton<GlobalMarketBloc>(
    GlobalMarketBloc(getIt<GlobalMarketRepository>(), getIt<Logger>()),
  );
}
