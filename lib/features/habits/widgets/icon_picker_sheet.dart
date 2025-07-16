import 'package:flutter/material.dart';

class IconPickerSheet extends StatelessWidget {
  final ValueChanged<String> onSelected;
  const IconPickerSheet({super.key, required this.onSelected});

  static const _icons = [
    '🔥','💧','🏃','📚','💪','🎯','🧘','🛏️','🚭','🥦','🎨','📖','⌚','🗒️','💡','🎵'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final icon in _icons)
              GestureDetector(
                onTap: () => onSelected(icon),
                child: CircleAvatar(
                  radius: 28,
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
