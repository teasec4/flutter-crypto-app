
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routepractice/features/auth/presentation/viewmodels/auth_view_model.dart';

final profileViewModelProvider = Provider<ProfileViewModel>((ref){
  final auth = ref.watch(authViewModelProvider.notifier);
  return ProfileViewModel(auth);
});

class ProfileViewModel {
  final AuthViewModel _authViewModel;

  ProfileViewModel(this._authViewModel);

  void logout(){
    _authViewModel.signOut();
  }
}