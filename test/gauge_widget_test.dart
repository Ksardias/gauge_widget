import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gauge_widget/gauge_widget.dart';

void main() {
  group('GaugeWidget', () {
    testWidgets('should render without title when title is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GaugeWidget(
              min: 0,
              max: 100,
              value: 50,
            ),
          ),
        ),
      );

      expect(find.byType(GaugeWidget), findsOneWidget);
    });

    testWidgets('should render with title when title is provided', (WidgetTester tester) async {
      const titleText = 'Test Gauge Title';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GaugeWidget(
              min: 0,
              max: 100,
              value: 50,
              title: titleText,
            ),
          ),
        ),
      );

      expect(find.byType(GaugeWidget), findsOneWidget);
      // Since the title is drawn using CustomPainter, we can't directly test for text
      // but we can ensure the widget accepts and stores the title parameter
      final gaugeWidget = tester.widget<GaugeWidget>(find.byType(GaugeWidget));
      expect(gaugeWidget.title, equals(titleText));
    });

    testWidgets('should accept custom title style', (WidgetTester tester) async {
      const titleText = 'Styled Title';
      const titleStyle = TextStyle(fontSize: 20, color: Colors.red);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GaugeWidget(
              min: 0,
              max: 100,
              value: 75,
              title: titleText,
              titleStyle: titleStyle,
            ),
          ),
        ),
      );

      final gaugeWidget = tester.widget<GaugeWidget>(find.byType(GaugeWidget));
      expect(gaugeWidget.title, equals(titleText));
      expect(gaugeWidget.titleStyle, equals(titleStyle));
    });
  });
}