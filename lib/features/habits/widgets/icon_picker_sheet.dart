import 'package:flutter/material.dart';

class IconPickerSheet extends StatelessWidget {
  final ValueChanged<String> onSelected;
  const IconPickerSheet({super.key, required this.onSelected});

  static const _icons = [
    '🔥', '💧', '🏃', '📚', '💪', '🎯', '🧘', '🛏️',
    '🚭', '🥦', '🎨', '📖', '⌚', '🗒️', '💡', '🎵',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .8,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: GridView.count(
            controller: controller,
            crossAxisCount: 6,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              for (final icon in _icons)
                InkWell(
                  onTap: () => onSelected(icon),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 24)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
