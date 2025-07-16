import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:habit_hero_app/features/dashboard/heatmap_widget.dart';

void main() {
  testWidgets('heatmap widget builds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeatMapWidget(data: {}, accent: Colors.purple),
        ),
      ),
    );
    expect(find.byType(HeatMapWidget), findsOneWidget);
  });
}
