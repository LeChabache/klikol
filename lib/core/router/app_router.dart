import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/otp_screen.dart';
import '../../features/feed/view/feed_screen.dart';
import '../../features/messaging/messaging_routes.dart'; // ✅
import '../../views/home_guest.dart';
import '../../views/home_loggedin.dart';
import '../../views/splash_screen.dart';
import '../providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: ListenableAdapter(authViewModel),
    redirect: (context, state) {
      final loggedIn = ref.read(authStateProvider).isLoggedIn;
      final location = state.uri.toString();
      final guestRoutes = ['/guest', '/feed', '/login', '/otp'];

      if (!loggedIn && !guestRoutes.contains(location)) return '/guest';
      if (loggedIn && (guestRoutes.contains(location) || location == '/')) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/guest', builder: (context, state) => const HomeGuest()),
      GoRoute(path: '/feed', builder: (context, state) => const FeedScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/otp', builder: (context, state) => const OtpScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeLoggedIn()),
      ...messagingRoutes, // ✅ Clean and modular
    ],
  );
});

class ListenableAdapter extends ChangeNotifier {
  ListenableAdapter(StateNotifier<dynamic> notifier) {
    notifier.addListener((_) => notifyListeners());
  }
}
