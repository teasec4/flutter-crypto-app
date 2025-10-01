import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/coin.dart';
import 'models/user.dart';
import 'app_router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CoinAdapter());
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<Coin>('coinsBoxV2');
  await Hive.openBox<User>('userBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,                     // базовый фон карточки
          surfaceTintColor: Colors.transparent,    // убираем M3-тинт, чтобы не серело/синело
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.black12, // подсветка активного таба
          iconTheme: MaterialStatePropertyAll(
            IconThemeData(color: Colors.grey),
          ),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ),
      routerConfig: router, // ⚡ это уровень MaterialApp, не внутри ThemeData!
    );
  }
}