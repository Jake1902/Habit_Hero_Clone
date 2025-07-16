import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyStateWidget({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 48, color: Colors.white54),
          const SizedBox(height: 12),
          Text('No habit found', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Create your first habit to get started',
              style: textTheme.bodySmall),
          const SizedBox(height: 16),
          PrimaryButton('Get started', onPressed: onCreate),
        ],
      ),
    );
  }
}
