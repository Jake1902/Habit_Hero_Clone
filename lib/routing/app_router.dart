import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../features/onboarding/onboarding_screen.dart';

class AppRouter {
  static GoRouter create(String initialRoute) {
    return GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        GoRoute(
          path: '/onboarding',
          pageBuilder: (_, __) => const MaterialPage(child: OnboardingScreen()),
        ),
      ],
    );
  }
}
