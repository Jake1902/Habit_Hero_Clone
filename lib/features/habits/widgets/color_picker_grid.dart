import 'package:flutter/material.dart';

const kAccent = Color(0xFF9E4DFF);

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
  final int selectedColor;
  final ValueChanged<int> onChanged;
  const ColorPickerGrid({super.key, required this.selectedColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        for (final c in _colors)
          InkWell(
            onTap: () => onChanged(c),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(c),
                borderRadius: BorderRadius.circular(8),
                border: selectedColor == c
                    ? Border.all(color: kAccent, width: 2)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
