import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_controller.dart';

const primary = Color(0xFF9E4DFF);

class IntroPage extends StatelessWidget {
  final OnboardingController controller;
  const IntroPage({super.key, required this.controller});

  List<Widget> _bullet(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: primary.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: color),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final headline = GoogleFonts.inter(
      textStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Welcome to', style: headline),
          RichText(
            text: TextSpan(
              style: headline,
              children: const [
                TextSpan(text: 'Habit'),
                TextSpan(text: 'Hero', style: TextStyle(color: primary)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ..._bullet(
            context,
            'Build new habits',
            'Create your habits and track your progress',
            Icons.playlist_add_check,
            const Color(0xFF9E4DFF),
          ),
          ..._bullet(
            context,
            'Check it off',
            'Mark when you completed your habits',
            Icons.task_alt,
            const Color(0xFF2CC55D),
          ),
          ..._bullet(
            context,
            'See the big picture',
            'Visualise completions in a tile grid',
            Icons.grid_view_rounded,
            const Color(0xFF3FA7F6),
          ),
          ..._bullet(
            context,
            'Get motivation from streaks',
            'Streak count shows consistency',
            Icons.local_fire_department,
            const Color(0xFFFF5D5D),
          ),
          ..._bullet(
            context,
            'Don\u2019t miss a completion',
            'Get notifications at set times',
            Icons.notifications_active,
            const Color(0xFFF8C231),
          ),
          const Spacer(),
          _PrimaryButton(label: 'Continue', onPressed: () => controller.next(context)),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
