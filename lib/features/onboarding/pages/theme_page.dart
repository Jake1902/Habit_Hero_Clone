import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/preferences_service.dart';
import '../../../core/data/providers.dart';
import '../onboarding_controller.dart';

class ThemePage extends ConsumerStatefulWidget {
  final OnboardingController controller;
  const ThemePage({super.key, required this.controller});

  @override
  ConsumerState<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends ConsumerState<ThemePage> {
  ThemeMode _mode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _mode = ref.read(themeModeProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose your theme',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  value: ThemeMode.system,
                  groupValue: _mode,
                  onChanged: (m) => setState(() => _mode = m!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: _mode,
                  onChanged: (m) => setState(() => _mode = m!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: _mode,
                  onChanged: (m) => setState(() => _mode = m!),
                ),
              ],
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Continue',
            onPressed: () async {
              await ref.read(themeModeProvider.notifier).setTheme(_mode);
              await PreferencesService.setFirstLaunchFalse();
              if (mounted) context.go('/');
            },
          ),
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
          backgroundColor: const Color(0xFF9E4DFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label),
      ),
    );
  }
}
