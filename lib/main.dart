import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepractice/core/di/service_locator.dart';
import 'package:routepractice/core/routing/app_router.dart';
import 'package:routepractice/core/secrets/app_secrets.dart';
import 'package:routepractice/core/theme/theme.dart';
import 'package:routepractice/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:routepractice/features/coin/presentation/bloc/coin_bloc.dart';
import 'package:routepractice/features/globalmarket/presentation/global_market_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('✅ Step 1: Widgets ready');

  await Supabase.initialize(
    url: AppSecrets.suppaBaseUrl,
    anonKey: AppSecrets.anonKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
    ),
  );
  debugPrint('✅ Step 2: Supabase initialized');

  setupServiceLocator();
  debugPrint('✅ Step 3: Service Locator initialized');

  initializeRouter();
  debugPrint('✅ Step 3.5: Router initialized');

  // final client = Supabase.instance.client;
  // try {
  //   await client.auth.signOut();
  //   debugPrint('✅ Supabase session cleared');
  // } catch (e) {
  //   debugPrint('⚠️ Failed to clear session: $e');
  // }

  runApp(const MyApp());
  debugPrint('✅ Step 4: runApp done');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider<CoinBloc>(
          create: (context) => getIt<CoinBloc>(),
        ),
        BlocProvider<GlobalMarketBloc>(
          create: (context) => getIt<GlobalMarketBloc>(),
        ),
      ],
      child: _AppWithNavigation(),
    );
  }
}

class _AppWithNavigation extends StatefulWidget {
  const _AppWithNavigation();

  @override
  State<_AppWithNavigation> createState() => _AppWithNavigationState();
}

class _AppWithNavigationState extends State<_AppWithNavigation> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, dynamic>(
      listener: (context, state) {
        // Trigger router to re-evaluate auth state and redirect if needed
        appRouter.refresh();
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        routerConfig: appRouter,
      ),
    );
  }
}