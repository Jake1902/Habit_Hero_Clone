import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/habits/add_edit_habit_screen.dart';

class AppRouter {
  static GoRouter create(String initialRoute) {
    return GoRouter(
      initialLocation: initialRoute,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          pageBuilder: (_, __) => const MaterialPage(child: OnboardingScreen()),
        ),
        GoRoute(
          path: '/add',
          pageBuilder: (_, __) => const MaterialPage(
            fullscreenDialog: true,
            child: AddEditHabitScreen(),
          ),
        ),
        GoRoute(
          path: '/edit/:id',
          builder: (_, state) =>
              AddEditHabitScreen(habitId: state.pathParameters['id']!),
        ),
      ],
    );
  }
}
