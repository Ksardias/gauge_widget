# gauge_widget

A customizable gauge widget for Flutter, supporting colored ranges, animated progress, and a needle indicator.

## Features
- Display a gauge with min, max, and current value
- Optional colored ranges for segments
- Animated progress arc (hidden if ranges are provided)
- Needle indicator
- Customizable size, thickness, and colors
- Optional value and label display
- Title display above the gauge
- ValueText display below the gauge

## Usage
Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  gauge_widget:
    path: ./lib
```

Import and use in your widget tree:

```dart
import 'package:gauge_widget/gauge_widget.dart';

GaugeWidget(
  min: 0,
  max: 100,
  value: 60,
  size: 200,
  thickness: 16,
  progressColor: Colors.blue,
  backgroundColor: Colors.grey[300]!,
  needleColor: Colors.red,
  title: "Performance Gauge",              // Title above gauge
  titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  valueText: "Current Status",             // Text below gauge
  valueTextStyle: TextStyle(fontSize: 14, color: Colors.grey),
  ranges: [
    GaugeRange(start: 0, end: 30, color: Colors.green),
    GaugeRange(start: 30, end: 70, color: Colors.orange),
    GaugeRange(start: 70, end: 100, color: Colors.red),
  ],
)
```

- If `ranges` are provided, the progress arc will not be shown (no color).
- If `ranges` are empty or null, the progress arc will be shown using `progressColor`.

## Title and ValueText

The gauge widget supports two text display options:

- **title**: Displayed above the gauge widget. Use this for the main label or heading.
- **valueText**: Displayed below the gauge widget. Use this for additional information or status text.

Both parameters are optional and can be styled independently:

```dart
GaugeWidget(
  // ... other parameters
  title: "CPU Usage",                    // Above gauge
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  valueText: "Current Load",             // Below gauge  
  valueTextStyle: TextStyle(
    fontSize: 16,
    color: Colors.grey,
  ),
)
```

## Example
See `lib/main.dart` for a usage example.

## Getting Started

For more information on Flutter development, see the [Flutter documentation](https://docs.flutter.dev/).
