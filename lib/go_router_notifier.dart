import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/auth/domain/user_model.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';

class GoRouterNotifier extends ChangeNotifier {
  final Ref ref;

  GoRouterNotifier(this.ref) {
    ref.listen<AsyncValue<UserModel?>>(
      authViewModelProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  AsyncValue<UserModel?> get authState => ref.read(authViewModelProvider);

  bool get isLoading => authState.isLoading;

  bool get isAuthenticated => authState.asData?.value != null;
}

final goRouterNotifierProvider = Provider((ref) => GoRouterNotifier(ref));