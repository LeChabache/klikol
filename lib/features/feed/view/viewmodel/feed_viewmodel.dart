import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedState {
  final List<dynamic> posts;
  final bool isLoading;
  final String? error;

  FeedState({this.posts = const [], this.isLoading = false, this.error});
}

class FeedViewModel extends StateNotifier<FeedState> {
  FeedViewModel() : super(FeedState());

  // TODO: Implement fetchPosts
}