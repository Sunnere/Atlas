import 'market_bar.dart';

enum SwingType {
  high,
  low,
}

enum SwingClassification {
  first,
  higherHigh,
  higherLow,
  lowerHigh,
  lowerLow,
}

class SwingPoint {
  final int index;
  final DateTime timestamp;
  final DateTime confirmedAt;
  final double price;
  final SwingType type;
  final SwingClassification classification;

  const SwingPoint({
    required this.index,
    required this.timestamp,
    required this.confirmedAt,
    required this.price,
    required this.type,
    required this.classification,
  });
}

class AtlasSwingEngine {
  final int strength;

  const AtlasSwingEngine({
    this.strength = 2,
  });

  List<SwingPoint> detect(List<MarketBar> bars) {
    if (strength < 1) {
      throw ArgumentError.value(
        strength,
        'strength',
        'must be greater than zero',
      );
    }

    if (bars.length < (strength * 2) + 1) {
      return const <SwingPoint>[];
    }

    final points = <SwingPoint>[];

    for (var i = strength;
        i < bars.length - strength;
        i++) {
      final bar = bars[i];

      if (_isSwingHigh(bars, i)) {
        points.add(
          SwingPoint(
            index: i,
            timestamp: bar.timestamp,
            confirmedAt: bars[i + strength].timestamp,
            price: bar.high,
            type: SwingType.high,
            classification: _classifyHigh(
              points,
              bar.high,
            ),
          ),
        );
      }

      if (_isSwingLow(bars, i)) {
        points.add(
          SwingPoint(
            index: i,
            timestamp: bar.timestamp,
            confirmedAt: bars[i + strength].timestamp,
            price: bar.low,
            type: SwingType.low,
            classification: _classifyLow(
              points,
              bar.low,
            ),
          ),
        );
      }
    }

    return List.unmodifiable(points);
  }

  bool _isSwingHigh(
    List<MarketBar> bars,
    int index,
  ) {
    final candidate = bars[index].high;

    for (var offset = 1; offset <= strength; offset++) {
      if (candidate <= bars[index - offset].high) {
        return false;
      }

      if (candidate <= bars[index + offset].high) {
        return false;
      }
    }

    return true;
  }

  bool _isSwingLow(
    List<MarketBar> bars,
    int index,
  ) {
    final candidate = bars[index].low;

    for (var offset = 1; offset <= strength; offset++) {
      if (candidate >= bars[index - offset].low) {
        return false;
      }

      if (candidate >= bars[index + offset].low) {
        return false;
      }
    }

    return true;
  }

  SwingClassification _classifyHigh(
    List<SwingPoint> points,
    double price,
  ) {
    final previousHigh = _lastPoint(
      points,
      SwingType.high,
    );

    if (previousHigh == null) {
      return SwingClassification.first;
    }

    return price > previousHigh.price
        ? SwingClassification.higherHigh
        : SwingClassification.lowerHigh;
  }

  SwingClassification _classifyLow(
    List<SwingPoint> points,
    double price,
  ) {
    final previousLow = _lastPoint(
      points,
      SwingType.low,
    );

    if (previousLow == null) {
      return SwingClassification.first;
    }

    return price > previousLow.price
        ? SwingClassification.higherLow
        : SwingClassification.lowerLow;
  }

  SwingPoint? _lastPoint(
    List<SwingPoint> points,
    SwingType type,
  ) {
    for (var i = points.length - 1; i >= 0; i--) {
      if (points[i].type == type) {
        return points[i];
      }
    }

    return null;
  }
}
