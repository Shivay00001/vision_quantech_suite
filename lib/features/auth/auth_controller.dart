import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import 'auth_repository.dart';

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (state) async {
      final session = state.session;
      if (session == null) return null;
      
      final repo = ref.read(authRepositoryProvider);
      return await repo.getUserProfile(session.user.id);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(false); // State = isLoading

  Future<UserProfile?> fetchProfileForRedirect(String userId) async {
    return _authRepository.getUserProfile(userId);
  }

  Future<String?> signIn(String email, String password) async {
    state = true;
    final result = await _authRepository.signIn(email: email, password: password);
    state = false;

    return result.fold(
      (error) => error,
      (response) => null, // Success
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
