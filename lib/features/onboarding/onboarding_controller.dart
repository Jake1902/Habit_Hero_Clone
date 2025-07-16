import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/preferences_service.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class OnboardingController {
  OnboardingController(this.ref);

  final WidgetRef ref;
  final PageController pageController = PageController();

  void onPageChanged(int index) {
    ref.read(currentPageProvider.notifier).state = index;
  }

  Future<void> next(BuildContext context) async {
    final page = ref.read(currentPageProvider); // read provider
    if (page >= 2) {
      await PreferencesService.setFirstLaunchFalse();
      if (context.mounted) context.go('/');
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip(BuildContext context) async {
    await PreferencesService.setFirstLaunchFalse();
    if (context.mounted) context.go('/');
  }
}
