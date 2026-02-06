import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(Supabase.instance.client));

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<Either<String, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return right(response);
    } on AuthException catch (e) {
      return left(e.message);
    } catch (e) {
      return left('An unexpected error occurred.');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserProfile.fromJson(data);
    } catch (e) {
      // If profile not found or RLS error, return null or handle appropriately
      // For now, logging might be good, but we return null
      return null;
    }
  }
}
