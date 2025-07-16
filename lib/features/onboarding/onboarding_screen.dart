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

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
        actions: [
          TextButton(
            onPressed: () => controller.skip(context),
            child: const Text('Skip', style: TextStyle(color: Colors.white70)),
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
            effect: const WormEffect(
              activeDotColor: Color(0xFF9E4DFF),
              dotColor: Colors.white24,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
  }
}
