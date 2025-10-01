import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String password; // 👈 простой пароль

  @HiveField(2)
  final List<String> favoriteIds;

  @HiveField(3)
  final bool isLoggedIn; // 👈 состояние входа

  User({
    required this.name,
    required this.password,
    required this.favoriteIds,
    required this.isLoggedIn,
  });

  User copyWith({
    String? name,
    String? password,
    List<String>? favoriteIds,
    bool? isLoggedIn,
  }) {
    return User(
      name: name ?? this.name,
      password: password ?? this.password,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}