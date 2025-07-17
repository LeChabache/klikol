import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionState {
  final String? tier;
  final bool isLoading;
  final String? error;

  SubscriptionState({this.tier, this.isLoading = false, this.error});
}

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  SubscriptionViewModel() : super(SubscriptionState());

  // TODO: Implement subscription logic
}