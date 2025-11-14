# SOLID анализ проекта routepractice

## 🟢 ✅ Хорошо соблюдается

### 1. **Single Responsibility Principle (SRP)** - 85% ✅

**Позитивные примеры:**

- **CoinRepository & CoinService**: Четко разделены интерфейс и реализация
  ```dart
  abstract interface class CoinRepository {
    Future<List<Coin>> getCoins({...});
    Future<Coin> getCoin(String id);
  }
  
  class CoinService implements CoinRepository { ... }
  ```

- **CoinNotifier**: Отвечает только за состояние списка монет (load, refresh, loadMore)

- **AuthService**: Отвечает исключительно за аутентификацию (signUp, signIn, signOut)

- **AuthViewModel**: Управляет состоянием авторизации и валидацией входных данных

**Проблемные места:**

⚠️ **coin_service.dart** - смешана логика маппинга (преобразование JSON → Coin) в методе
```dart
return data.map((json) {
  return Coin(
    id: json['id'],
    name: json['name'],
    // ... 7 полей маппинга
  );
}).toList();
```

**Решение:** Создать отдельный `CoinMapper` класс:
```dart
class CoinMapper {
  static Coin fromJson(Map<String, dynamic> json) => Coin(...);
}
```

---

## 🟡 ⚠️ Частично соблюдается

### 2. **Open/Closed Principle (OCP)** - 70% ⚠️

**Позитивные примеры:**

- Использование `CoinRepository` абстракции позволяет легко добавлять новые реализации

**Проблемные места:**

❌ **coin_view_model.dart** - сложно добавлять новую логику обработки состояний:
```dart
Future<void> loadInitial() async {
  try {
    final coins = await _repo.getCoins(page: 1, perPage: 30);
    state = AsyncData(coins);
  } catch (e, st) {
    state = AsyncError(e, st);
    Future.delayed(const Duration(seconds: 5), () {
      loadInitial(); // ПОВТОРНОЕ ПОДКЛЮЧЕНИЕ ЖЕСТКО ЗАКОДИРОВАНО
    });
  }
}
```

**Проблема:** Логика retry жестко закодирована, сложно менять стратегию повторных попыток.

**Решение:** Создать отдельный `RetryStrategy`:
```dart
abstract class RetryStrategy {
  Future<T> execute<T>(Future<T> Function() operation);
}

class ExponentialBackoffRetry implements RetryStrategy { ... }
```

---

❌ **app_scaffold.dart** - новый тип данных требует изменения класса:
```dart
String _getDetailTitle(BuildContext context, String location) {
  final state = GoRouterState.of(context);
  final extra = state.extra;

  if (extra is Coin) {
    return extra.name;
  }
  // Если добавить Profile детали - нужно менять этот файл
  return 'Details';
}
```

**Решение:** Используйте паттерн `DetailPageable`:
```dart
abstract interface class DetailPageable {
  String get detailTitle;
}

// Тогда:
if (extra is DetailPageable) {
  return extra.detailTitle;
}
```

---

### 3. **Liskov Substitution Principle (LSP)** - 80% ⚠️

**Позитивные примеры:**

- `AuthService` корректно реализует контракты (возвращает `Either<Failure, UserModel>`)

**Потенциальные проблемы:**

⚠️ **coin_service.dart** - разные методы возвращают разные типы ошибок:
```dart
// getCoins()
} on TimeoutException {
  throw Exception('⏰ Request timed out...');
} catch (e) {
  throw Exception('❌ Unexpected error: $e');
}

// getCoin()
} on TimeoutException {
  throw Exception('⏰ Request timed out...');
} catch (e) {
  throw Exception('❌ Unexpected error: $e');
}
```

**Проблема:** Обе реализации почти идентичны, нужна общая обработка ошибок.

**Решение:**
```dart
class CoinService implements CoinRepository {
  Future<T> _executeRequest<T>(Future<T> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw Exception('⏰ Request timed out...');
    } catch (e) {
      throw Exception('❌ Unexpected error: $e');
    }
  }
  
  Future<List<Coin>> getCoins(...) => _executeRequest(() async { ... });
  Future<Coin> getCoin(String id) => _executeRequest(() async { ... });
}
```

---

## 🔴 ❌ Плохо соблюдается

### 4. **Interface Segregation Principle (ISP)** - 60% ❌

**Проблемные места:**

❌ **profile_page.dart** - наблюдает за слишком большим количеством провайдеров:
```dart
final profileVM = ref.watch(profileViewModelProvider);
final authState = ref.watch(authViewModelProvider);
```

Но использует только `authState` для отображения. Профиль страница имеет дело с UI элементами, которые не зависят от ProfileViewModel.

❌ **coin_page.dart** - CoinPage использует слишком много "ответственности":
- Управление прокруткой (ScrollController)
- Инициализация listener'а
- Отображение состояния (data/error/loading)
- Обработка refresh'а

**Решение:** Разбить на меньшие компоненты:
```dart
class CoinListViewWidget extends ConsumerWidget {
  final List<Coin> coins;
  final bool isLoadingMore;
  final Function() onLoadMore;
  final Function() onRefresh;
}

class CoinPage extends ConsumerWidget {
  // Только управляет состоянием и компоновкой
}
```

---

### 5. **Dependency Inversion Principle (DIP)** - 75% ⚠️

**Позитивные примеры:**

✅ **CoinNotifier зависит от абстракции**:
```dart
class CoinNotifier extends StateNotifier<AsyncValue<List<Coin>>> {
  final CoinRepository _repo; // ✅ Зависит от интерфейса
}
```

✅ **AuthViewModel зависит от абстракции**:
```dart
class AuthViewModel extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _service; // ✅ Зависит от сервиса
}
```

**Проблемные места:**

❌ **app_scaffold.dart** - жестко зависит от конкретного типа `Coin`:
```dart
if (extra is Coin) {
  return extra.name;
}
```

❌ **coin_page.dart** - прямая зависимость от ScrollController (Flutter widget):
```dart
class _CoinPageState extends ConsumerState<CoinPage> {
  final scrollController = ScrollController(); // Жесткая зависимость
  
  scrollController.addListener(() {
    // Логика обработки скролла смешана с UI
  });
}
```

**Решение:** Создать абстракцию для прокрутки:
```dart
abstract interface class ScrollListener {
  void onScroll(ScrollPosition position);
}

class InfiniteScrollPaginationListener implements ScrollListener {
  final CoinNotifier notifier;
  
  @override
  void onScroll(ScrollPosition position) {
    if (position.pixels >= position.maxScrollExtent - 200) {
      notifier.loadMore();
    }
  }
}
```

---

## 📋 Итоговая сводка

| Принцип | Оценка | Статус |
|---------|--------|--------|
| **S**ingle Responsibility | 85% | 🟢 Хорошо |
| **O**pen/Closed | 70% | 🟡 Нужны улучшения |
| **L**iskov Substitution | 80% | 🟡 Нужны улучшения |
| **I**nterface Segregation | 60% | 🔴 Нужно переделать |
| **D**ependency Inversion | 75% | 🟡 Нужны улучшения |
| **Итого** | **74%** | 🟡 |

---

## 🎯 Приоритетные действия для улучшения

### Высокий приоритет (требуют срочного исправления):

1. **Создать CoinMapper** - отделить маппинг от сервиса
2. **Создать RetryStrategy** - вынести логику повторных попыток
3. **Разбить CoinPage на компоненты** - уменьшить сложность
4. **Создать DetailPageable интерфейс** - сделать app_scaffold открытым для расширения

### Средний приоритет:

5. **Создать ScrollPaginationListener** - вынести логику прокрутки из UI
6. **Унифицировать обработку ошибок** - создать общую функцию `_executeRequest`
7. **Разделить ответственность ProfilePage** - использовать только нужные провайдеры

### Низкий приоритет:

8. Добавить Logger интерфейс вместо print()
9. Создать Exception иерархию вместо общего `Exception`

---

## 🔧 Примеры рефакторинга

### 1️⃣ CoinMapper (для SRP)

```dart
class CoinMapper {
  static Coin fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price: (json['current_price'] ?? 0).toDouble(),
      imageUrl: json['image'],
      marketCap: json['market_cap_rank'].toString(),
      priceChange24H: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24H:
          (json['price_change_percentage_24h'] ?? 0).toDouble(),
    );
  }
}

// В CoinService:
return data.map((json) => CoinMapper.fromJson(json)).toList();
```

### 2️⃣ DetailPageable (для OCP)

```dart
abstract interface class DetailPageable {
  String get detailTitle;
}

class Coin implements DetailPageable {
  @override
  String get detailTitle => name;
}

// В app_scaffold.dart:
String _getDetailTitle(BuildContext context, String location) {
  final state = GoRouterState.of(context);
  final extra = state.extra;
  
  if (extra is DetailPageable) {
    return extra.detailTitle;
  }
  
  return 'Details';
}
```

### 3️⃣ RetryStrategy (для OCP)

```dart
abstract interface class RetryStrategy {
  Future<T> execute<T>(Future<T> Function() operation);
}

class ExponentialBackoffRetry implements RetryStrategy {
  final int maxAttempts;
  final Duration initialDelay;
  
  ExponentialBackoffRetry({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 5),
  });
  
  @override
  Future<T> execute<T>(Future<T> Function() operation) async {
    int attempt = 0;
    
    while (attempt < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) rethrow;
        await Future.delayed(initialDelay * pow(2, attempt - 1));
      }
    }
    throw Exception('Max retries exceeded');
  }
}

// В CoinNotifier:
class CoinNotifier extends StateNotifier<AsyncValue<List<Coin>>> {
  final CoinRepository _repo;
  final RetryStrategy _retryStrategy;
  
  Future<void> loadInitial() async {
    try {
      final coins = await _retryStrategy.execute(
        () => _repo.getCoins(page: 1, perPage: 30),
      );
      state = AsyncData(coins);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
```

### 4️⃣ CoinListWidget (для ISP)

```dart
class CoinListWidget extends ConsumerWidget {
  final List<Coin> coins;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Function() onLoadMore;
  final Function() onRefresh;
  
  const CoinListWidget({
    required this.coins,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onLoadMore,
    required this.onRefresh,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppPalette.accent,
      backgroundColor: AppPalette.background,
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: coins.length + 1,
        itemBuilder: (context, i) {
          if (i == coins.length) {
            return isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppPalette.accent),
                  )
                : const SizedBox.shrink();
          }
          return CoinTile(coin: coins[i]);
        },
      ),
    );
  }
}

// В CoinPage:
class CoinPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends ConsumerState<CoinPage> {
  late ScrollController scrollController;
  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    final notifier = ref.read(coinNotifierProvider.notifier);
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200 &&
        !notifier.isLoadingMore) {
      notifier.loadMore();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final coinsAsync = ref.watch(coinNotifierProvider);
    final notifier = ref.read(coinNotifierProvider.notifier);
    
    return coinsAsync.when(
      data: (coins) => SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            GlobalMarketHeader(),
            const Divider(color: AppPalette.accent, height: 1),
            Expanded(
              child: CoinListWidget(
                coins: coins,
                isLoadingMore: notifier.isLoadingMore,
                scrollController: scrollController,
                onLoadMore: () => notifier.loadMore(),
                onRefresh: () => notifier.refresh(),
              ),
            ),
          ],
        ),
      ),
      error: (err, _) => ErrorView(
        error: err.toString(),
        onRetry: () => notifier.refresh(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppPalette.accent),
      ),
    );
  }
}
```

---

## ✅ Выводы

Проект имеет **хорошую архитектуру** и использует современные паттерны (Riverpod, Repository Pattern), но есть места, где нужно **применить SOLID принципы** для повышения гибкости и тестируемости кода.

**Основные рекомендации:**
1. Использовать маппер-классы для преобразования данных
2. Создавать абстракции для повторяющейся логики (retry, скролл)
3. Разбивать крупные компоненты на меньшие
4. Использовать интерфейсы вместо конкретных типов в сигнатурах методов
