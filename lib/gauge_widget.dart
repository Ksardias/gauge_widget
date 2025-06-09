import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class GaugeRange {
  final double start;
  final double end;
  final Color color;
  GaugeRange({required this.start, required this.end, required this.color});
}

class GaugeWidget extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final double size;
  final double thickness;
  final Color backgroundColor;
  final Color progressColor;
  final Color needleColor;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final bool showValue;
  final bool showLabels;
  final bool showNeedle;
  final List<GaugeRange>? ranges;
  final String? title;
  final TextStyle? titleStyle;

  const GaugeWidget({
    Key? key,
    required this.min,
    required this.max,
    required this.value,
    this.size = 200,
    this.thickness = 16,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.needleColor = Colors.red,
    this.valueStyle,
    this.labelStyle,
    this.showValue = true,
    this.showLabels = true,
    this.showNeedle = true,
    this.ranges,
    this.title,
    this.titleStyle,
  }) : super(key: key);

  @override
  State<GaugeWidget> createState() => _GaugeWidgetState();
}

class _GaugeWidgetState extends State<GaugeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _oldValue = 0;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(
      begin: _oldValue,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(GaugeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _oldValue = _animation.value;
      _animation = Tween<double>(
        begin: _oldValue,
        end: widget.value,
      ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          return CustomPaint(
            painter: _GaugePainter(
              min: widget.min,
              max: widget.max,
              value: _animation.value,
              thickness: widget.thickness,
              backgroundColor: widget.backgroundColor,
              progressColor: widget.progressColor,
              needleColor: widget.needleColor,
              labelStyle: widget.labelStyle,
              showLabels: widget.showLabels,
              showNeedle: widget.showNeedle,
              ranges: widget.ranges,
              title: widget.title,
              titleStyle: widget.titleStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            child: null,
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double min;
  final double max;
  final double value;
  final double thickness;
  final Color backgroundColor;
  final Color progressColor;
  final Color needleColor;
  final TextStyle? labelStyle;
  final bool showLabels;
  final bool showNeedle;
  final List<GaugeRange>? ranges;
  final String? title;
  final TextStyle? titleStyle;

  _GaugePainter({
    required this.min,
    required this.max,
    required this.value,
    required this.thickness,
    required this.backgroundColor,
    required this.progressColor,
    required this.needleColor,
    required this.labelStyle,
    required this.showLabels,
    required this.showNeedle,
    this.ranges,
    this.title,
    this.titleStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - thickness / 2;
    // Zmieniamy zakres z 180 na 270 stopni
    final startAngle = 3 * pi / 4; // 135°
    final sweepAngle = 3 * pi / 2; // 270°

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw colored ranges if provided
    if (ranges != null && ranges!.isNotEmpty) {
      for (final range in ranges!) {
        final rangeStartPercent =
            ((range.start - min) / (max - min)).clamp(0.0, 1.0);
        final rangeEndPercent =
            ((range.end - min) / (max - min)).clamp(0.0, 1.0);
        final rangeStartAngle = startAngle + sweepAngle * rangeStartPercent;
        final rangeSweepAngle =
            sweepAngle * (rangeEndPercent - rangeStartPercent);
        final rangePaint = Paint()
          ..color = range.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(
            rect, rangeStartAngle, rangeSweepAngle, false, rangePaint);
      }
    } else {
      // Draw background arc if no ranges
      final bgPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);
    }

    // Progress Arc
    if (ranges == null || ranges!.isEmpty) {
      final percent = ((value - min) / (max - min)).clamp(0.0, 1.0);
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
          rect, startAngle, sweepAngle * percent, false, progressPaint);
    }

    // Labels
    if (showLabels) {
      final labelRadius = radius - thickness - 10;
      const interval = 0.1;
      for (double p = 0; p <= 1.001; p += interval) {
        final angle = startAngle + sweepAngle * p;
        final labelValue = (min + (max - min) * p).round();
        final labelOffset = Offset(
          center.dx + labelRadius * cos(angle),
          center.dy + labelRadius * sin(angle),
        );

        final tp = TextPainter(
          text: TextSpan(
            text: labelValue.toString(),
            style: labelStyle ??
                const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, labelOffset - Offset(tp.width / 2, tp.height / 2));
      }
    }

    // Needle
    if (showNeedle) {
      final needleLength = radius - thickness / 2;
      final percent = ((value - min) / (max - min)).clamp(0.0, 1.0);
      final angle = startAngle + sweepAngle * percent;
      final needlePaint = Paint()..color = needleColor;
      final tip = Offset(
        center.dx + needleLength * cos(angle),
        center.dy + needleLength * sin(angle),
      );

      final path = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(
          center.dx + 12 * cos(angle + pi / 2),
          center.dy + 12 * sin(angle + pi / 2),
        )
        ..lineTo(
          center.dx + 12 * cos(angle - pi / 2),
          center.dy + 12 * sin(angle - pi / 2),
        )
        ..close();

      canvas.drawShadow(path, Colors.black45, 4, false);
      canvas.drawPath(path, needlePaint);

      // Center dot (dynamically sized to fit value)
      final valueText = value.round().toString();
      final textPainter = TextPainter(
        text: TextSpan(
          text: valueText,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      const dotPadding = 12.0;
      final dotRadius = (textPainter.width > textPainter.height
                  ? textPainter.width
                  : textPainter.height) /
              2 +
          dotPadding;
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(center, dotRadius, dotPaint);
      canvas.drawCircle(center, dotRadius, borderPaint);
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Draw title if provided
    if (title != null && title!.isNotEmpty) {
      final titleTextPainter = TextPainter(
        text: TextSpan(
          text: title,
          style: titleStyle ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      titleTextPainter.layout(maxWidth: size.width * 0.8);

      final labelRadius = radius - thickness - 10;
      // Calculate the position for the title based on the label positions
      final firstLabelAngle = startAngle;
      final lastLabelAngle = startAngle + sweepAngle;
      final firstLabelY = center.dy + labelRadius * sin(firstLabelAngle);
      final lastLabelY = center.dy + labelRadius * sin(lastLabelAngle);
      final titleY = (firstLabelY + lastLabelY) / 2;
      final titleOffset = Offset(
        (size.width - titleTextPainter.width) / 2,
        titleY + 18, // +18 to position below the labels
      );
      titleTextPainter.paint(canvas, titleOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
