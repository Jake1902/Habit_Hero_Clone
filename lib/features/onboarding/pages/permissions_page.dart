import 'package:flutter/material.dart';

import '../onboarding_controller.dart';

class PermissionsPage extends StatefulWidget {
  final OnboardingController controller;
  const PermissionsPage({super.key, required this.controller});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool allowNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Icon(Icons.notifications_active,
                  size: 120, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Text('Stay on track',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text('Enable reminders so you never miss a completion',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SwitchListTile.adaptive(
                title: const Text('Allow notifications'),
                value: allowNotifications,
                onChanged: (v) => setState(() => allowNotifications = v),
              ),
            ),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'Continue',
            onPressed: () => widget.controller.next(context),
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
