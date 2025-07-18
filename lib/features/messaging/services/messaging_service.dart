class MessagingService {
  Future<List<String>> fetchMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['Message 1', 'Message 2', 'Message 3'];
  }
}
