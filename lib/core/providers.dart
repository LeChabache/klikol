import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/auth/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(ref),
);

final authStateProvider = Provider<AuthState>((ref) => ref.watch(authViewModelProvider));

final firebaseUserProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());