import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/providers.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? verificationId;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.verificationId,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? verificationId,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      verificationId: verificationId ?? this.verificationId,
      error: error,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthViewModel(this._ref) : super(AuthState()) {
    _ref.listen<AsyncValue<User?>>(firebaseUserProvider, (_, user) {
      state = state.copyWith(isLoggedIn: user.value != null);
    });
  }

  Future<void> sendCode(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    final authService = _ref.read(authServiceProvider);
    try {
      await authService.verifyPhone(
        phone: phone,
        onCodeSent: (verificationId, _) {
          state = state.copyWith(isLoading: false, verificationId: verificationId);
        },
        onFailed: (error) {
          state = state.copyWith(isLoading: false, error: error.message ?? 'Failed to send code');
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyCode(String smsCode) async {
    if (state.verificationId == null) {
      state = state.copyWith(error: 'No verification ID found.');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    final authService = _ref.read(authServiceProvider);
    try {
      await authService.signInWithOtp(state.verificationId!, smsCode);
      state = state.copyWith(isLoading: false, isLoggedIn: true, verificationId: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    final authService = _ref.read(authServiceProvider);
    try {
      await authService.signOut();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}