# 💰 Flutter Crypto App

A modern **cryptocurrency** and **NFT tracking** application built with Flutter, demonstrating **Clean Architecture** principles and best practices in modern mobile development.

![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-teal.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean-brightgreen.svg)
![State Management](https://img.shields.io/badge/State%20Management-Riverpod%202.6.1-orange.svg)

---

## 📸 Screenshots

> Add your app screenshots here once ready.

---

## ✨ Features

- 💰 **Cryptocurrency Tracking** – Real-time crypto market data from CoinGecko
- 🎨 **NFT Marketplace** – Browse NFT collections via Reservoir API
- ⭐ **Favorites System** – Save and manage your favorite coins and NFTs
- 🔐 **Authentication** – Secure user authentication with Supabase
- 📊 **Detailed Analytics** – View comprehensive coin and NFT details
- 🌙 **Theme Support** – Light and dark mode
- 📱 **Responsive Design** – Optimized for all screen sizes

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns across three layers:

```
lib/
├── core/                          # Shared utilities and base classes
│   ├── constants/                 # App-wide constants
│   ├── errors/                    # Error handling
│   ├── network/                   # HTTP client configuration
│   ├── theme/                     # App theming
│   └── utils/                     # Helper functions
├── features/                      # Feature modules
│   ├── coin/                      # Cryptocurrency feature
│   │   ├── data/                  # Data layer
│   │   │   ├── coin_service.dart  # API service
│   │   │   ├── models/            # Data models
│   │   │   └── coin_repository_impl.dart
│   │   ├── domain/                # Business logic layer
│   │   │   ├── entities/          # Domain entities
│   │   │   └── coin_repository.dart
│   │   └── presentation/          # UI layer
│   │       ├── pages/             # Screens
│   │       ├── widgets/           # Reusable widgets
│   │       └── providers/         # Riverpod providers
```

---

### 🧩 Architecture Layers

**Data Layer**
- API services for external data sources
- Data models with JSON serialization
- Repository implementations
- Local storage management

**Domain Layer**
- Business entities
- Repository interfaces
- Use cases (business logic)

**Presentation Layer**
- UI screens and widgets
- Riverpod providers for state management
- View models

---

## 🛠️ Tech Stack

**Core**
- Flutter SDK: `3.9+`
- Dart: `3.9.2+`
- Architecture: Clean Architecture
- State Management: Riverpod 2.6.1

**Key Dependencies**

| Package | Purpose |
|----------|----------|
| `riverpod` / `flutter_riverpod` | State management & dependency injection |
| `go_router` | Declarative routing & navigation |
| `dio` | HTTP client for API requests |
| `fpdart` | Functional programming (Either for error handling) |
| `supabase_flutter` | Backend-as-a-Service (Auth + Database) |
| `shared_preferences` | Local data persistence |
| `cached_network_image` | Image caching and loading |
| `flutter_svg` | SVG rendering |
| `intl` | Internationalization and formatting |

---

## 📦 API Integrations

### 🪙 CoinGecko API
Free cryptocurrency data API providing:
- Market data for 10,000+ cryptocurrencies
- Price charts and historical data
- Market statistics and trends
- No API key required

**Base URL:** `https://api.coingecko.com/api/v3/`

---

### 🎨 Reservoir API
NFT marketplace aggregator providing:
- NFT collection data
- Floor prices and sales
- Collection metadata

**Base URL:** `https://api.reservoir.tools/`  
(May require API key for production)

---

### 🧰 Supabase
Used for:
- User authentication (email/password)
- Session management
- Database operations

---

## 🚀 Getting Started

### 🧱 Prerequisites
- Flutter SDK 3.9 or higher
- Dart 3.9.2 or higher
- iOS Simulator / Android Emulator or physical device
- Supabase account (for authentication features)

### 🔧 Installation

#### 1️⃣ Clone the repository
```bash
git clone https://github.com/teasec4/flutter-crypto-app.git
cd flutter-crypto-app
```

#### 2️⃣ Install dependencies
```bash
flutter pub get
```

#### 3️⃣ Configure Supabase
Create file `lib/core/secrets/app_secrets.dart`:
```dart
class AppSecrets {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

Get your credentials from [Supabase](https://supabase.com):
- Create a new project
- Go to **Settings → API**
- Copy the **Project URL** and **anon/public key**

#### 4️⃣ Run the app
```bash
flutter run
```

#### 5️⃣ Build for production

📱 **Android**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

🍎 **iOS**
```bash
flutter build ios --release
```

---

## 🎯 Project Structure Highlights

### 🌀 State Management with Riverpod
```dart
final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinRepositoryImpl(CoinService());
});

final coinListProvider = StateNotifierProvider<CoinListNotifier, AsyncValue<List<Coin>>>((ref) {
  return CoinListNotifier(ref.read(coinRepositoryProvider));
});
```

---

### 🧠 Functional Error Handling
```dart
Future<Either<Failure, List<Coin>>> getCoins() async {
  try {
    final coins = await _service.fetchCoins();
    return Right(coins);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

---

### 🗺️ Navigation with Go Router
```dart
final router = GoRouter(
  redirect: (context, state) {
    // Auth guard logic
  },
  routes: [
    StatefulShellRoute(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Coins, NFTs, Favorites, Profile tabs
      ],
    ),
  ],
);
```

---

## 📚 What You Can Learn

✅ Clean Architecture – Proper separation of concerns  
✅ Riverpod – Modern state management & DI  
✅ Go Router – Declarative navigation  
✅ Functional Programming – Robust error handling  
✅ API Integration – REST APIs  
✅ Supabase – Authentication & backend  
✅ Repository Pattern – Data abstraction  
✅ Dependency Injection – Testable code  
✅ Responsive UI – Adaptive layouts  
✅ Local Storage – Favorites persistence

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test
```

---

## 📱 Features Breakdown

### 🪙 Coin Feature
- Browse cryptocurrency market
- Search and filter coins
- View detailed coin information
- Price charts and statistics
- Add to favorites

### 🎨 NFT Feature
- Explore NFT collections
- View collection details
- Floor prices and volume
- Metadata display

### ⭐ Favorites Feature
- Save favorite coins & NFTs
- Local persistence
- Quick access to saved items

### 🔐 Auth Feature
- Email/password authentication
- Session management
- Protected routes
- User profile

---

## ⚙️ Configuration

Example environment config:
```dart
class EnvConfig {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.coingecko.com/api/v3/',
  );
}
```

Run with:
```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com
```

---

## 🤝 Contributing

1. Fork the project
2. Create a feature branch:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a Pull Request

---

## 📄 License

This project was created for **educational purposes**.

---

## 👤 Author

**teasec4**
- GitHub: [@teasec4](https://github.com/teasec4)

---

## 🙏 Acknowledgments

- [CoinGecko](https://www.coingecko.com/) – for free crypto API
- [Reservoir](https://reservoir.tools/) – for NFT data
- [Supabase](https://supabase.com/) – for backend services
- Flutter & Dart communities for excellent tools

---

## 📖 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Clean Architecture Guide](https://resocoder.com/category/clean-architecture/)
- [Go Router Documentation](https://pub.dev/packages/go_router)

---

⭐️ **If this project helped you learn Flutter and Clean Architecture, give it a star!**
