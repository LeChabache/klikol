import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingState {
  final List<dynamic> messages;
  final bool isLoading;
  final String? error;

  MessagingState({this.messages = const [], this.isLoading = false, this.error});
}

class MessagingViewModel extends StateNotifier<MessagingState> {
  MessagingViewModel() : super(MessagingState());

  // TODO: Implement sendMessage and fetchMessages
}