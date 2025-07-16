import 'package:flutter/material.dart';

const _colors = [
  0xFF9E4DFF,
  0xFFFF5D5D,
  0xFF2CC55D,
  0xFF3FA7F6,
  0xFFF8C231,
  0xFFFFA500,
  0xFF8BC34A,
  0xFF03A9F4,
  0xFFE91E63,
  0xFF009688,
  0xFF795548,
  0xFFCDDC39,
  0xFFFF9800,
  0xFF607D8B,
  0xFFFFC107,
  0xFF673AB7,
];

class ColorPickerGrid extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const ColorPickerGrid({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _colors.length,
      itemBuilder: (_, i) {
        final color = _colors[i];
        final isSelected = color == selected;
        return GestureDetector(
          onTap: () => onChanged(color),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(color),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
