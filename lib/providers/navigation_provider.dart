import 'package:riverpod/legacy.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 0; // Initial value

  void setIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);