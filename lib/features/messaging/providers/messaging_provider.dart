import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulated async message fetch (replace with your service calls)
final messagingProvider = StateNotifierProvider<MessagingNotifier, AsyncValue<List<String>>>(
  (ref) => MessagingNotifier(),
);

class MessagingNotifier extends StateNotifier<AsyncValue<List<String>>> {
  MessagingNotifier() : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    await Future.delayed(const Duration(seconds: 10)); // simulate network
    state = AsyncValue.data(['Hello!', 'How are you?', 'This is a message.']);
  }
}
