import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import 'message_list_screen.dart';
import 'message_detail_screen.dart';

class MessagingScreen extends ConsumerStatefulWidget {
  const MessagingScreen({super.key});

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends ConsumerState<MessagingScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (!authState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/guest');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState != null &&
            _navigatorKey.currentState!.canPop()) {
          _navigatorKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: '/messaging/list',
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/messaging/list':
              page = const MessageListScreen();
              break;
            case '/messaging/detail':
              final args = settings.arguments as Map<String, dynamic>?;
              final messageId = args?['id'] ?? '';
              page = MessageDetailScreen(messageId: messageId);
              break;
            default:
              page = const MessageListScreen();
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }
}
