import 'package:go_router/go_router.dart';
import 'view/messaging_screen.dart';

final List<GoRoute> messagingRoutes = [
  GoRoute(
    path: '/messaging',
    builder: (context, state) => const MessagingScreen(),
  ),
];
