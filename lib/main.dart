import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/providers.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view/otp_screen.dart';
import 'views/home_guest.dart';
import 'views/home_loggedin.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final router = GoRouter(
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
        GoRoute(
          path: '/feed',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Feed'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Feed Placeholder')),
          ),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/otp', builder: (context, state) => const OtpScreen()),
        GoRoute(path: '/home', builder: (context, state) => const HomeLoggedIn()),
        GoRoute(
          path: '/messaging',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Messages'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Messaging Placeholder')),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Klikol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class ListenableAdapter extends ChangeNotifier {
  ListenableAdapter(StateNotifier<dynamic> notifier) {
    notifier.addListener((_) => notifyListeners());
  }
}
