import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_controller.dart';
import 'pages/intro_page.dart';
import 'pages/permissions_page.dart';
import 'pages/theme_page.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = OnboardingController(ref);
    final pages = [
      IntroPage(controller: controller),
      PermissionsPage(controller: controller),
      ThemePage(controller: controller),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.skip(context),
            child: Text('Skip',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: pages,
            ),
          ),
          const SizedBox(height: 24),
          SmoothPageIndicator(
            controller: controller.pageController,
            count: pages.length,
            effect: WormEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.24),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
