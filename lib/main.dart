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
import 'features/messaging/view/messaging_screen.dart';
import 'core/router/app_router.dart';
import 'features/feed/view/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Klikol',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}

class ListenableAdapter extends ChangeNotifier {
  ListenableAdapter(StateNotifier<dynamic> notifier) {
    notifier.addListener((_) => notifyListeners());
  }
}
