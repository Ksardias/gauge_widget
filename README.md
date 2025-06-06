# gauge_widget

A customizable gauge widget for Flutter, supporting colored ranges, animated progress, and a needle indicator.

## Features
- Display a gauge with min, max, and current value
- Optional colored ranges for segments
- Animated progress arc (hidden if ranges are provided)
- Needle indicator
- Customizable size, thickness, and colors
- Optional value and label display

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
  ranges: [
    GaugeRange(start: 0, end: 30, color: Colors.green),
    GaugeRange(start: 30, end: 70, color: Colors.orange),
    GaugeRange(start: 70, end: 100, color: Colors.red),
  ],
)
```

- If `ranges` are provided, the progress arc will not be shown (no color).
- If `ranges` are empty or null, the progress arc will be shown using `progressColor`.

## Example
See `lib/main.dart` for a usage example.

## Getting Started

For more information on Flutter development, see the [Flutter documentation](https://docs.flutter.dev/).
