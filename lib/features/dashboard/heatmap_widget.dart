import 'package:flutter/material.dart';

class HeatMapWidget extends StatelessWidget {
  final Map<DateTime, int> data;
  final Color accent;
  final double tileSize;
  final double spacing;

  const HeatMapWidget({
    super.key,
    required this.data,
    required this.accent,
    this.tileSize = 8,
    this.spacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final width = (tileSize + spacing) * 60;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: OverflowBox(
        minWidth: width,
        maxWidth: width,
        alignment: Alignment.centerLeft,
        child: CustomPaint(
          size: Size(width, (tileSize + spacing) * 7),
          painter: _HeatMapPainter(
            data: data,
            accent: accent,
            today: today,
            tileSize: tileSize,
            spacing: spacing,
          ),
        ),
      ),
    );
  }
}

class _HeatMapPainter extends CustomPainter {
  final Map<DateTime, int> data;
  final Color accent;
  final DateTime today;
  final double tileSize;
  final double spacing;

  _HeatMapPainter({
    required this.data,
    required this.accent,
    required this.today,
    required this.tileSize,
    required this.spacing,
  });

  static const _bg = Color(0xFF000000);

  DateTime _dateFor(int col, int row) {
    final days = (59 - col) * 7 + (6 - row);
    return DateUtils.dateOnly(today.subtract(Duration(days: days)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(2);
    final paint = Paint();

    for (int c = 0; c < 60; c++) {
      for (int r = 0; r < 7; r++) {
        final rect = Rect.fromLTWH(
          c * (tileSize + spacing),
          r * (tileSize + spacing),
          tileSize,
          tileSize,
        );
        final date = _dateFor(c, r);
        final val = data[date] ?? 0;
        Color color = _bg.withOpacity(.15);
        if (val == 1) color = accent.withOpacity(.60);
        if (val >= 2) color = accent.withOpacity(.95);
        paint.color = color;
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatMapPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.accent != accent ||
        oldDelegate.today != today;
  }
}
