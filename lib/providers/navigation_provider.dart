

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 1; // Initial value

  void setIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);