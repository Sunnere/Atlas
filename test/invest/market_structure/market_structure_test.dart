import 'package:test/test.dart';

import '../../../lib/invest/market_structure/market_structure.dart';
import '../../../lib/invest/market_structure/swing_engine.dart';

SwingPoint swingHigh(
  int index,
  double price,
  SwingClassification classification,
) {
  final timestamp = DateTime.utc(
    2026,
    1,
    index + 1,
  );

  return SwingPoint(
    index: index,
    timestamp: timestamp,
    confirmedAt: timestamp.add(const Duration(days: 1)),
    price: price,
    type: SwingType.high,
    classification: classification,
  );
}

SwingPoint swingLow(
  int index,
  double price,
  SwingClassification classification,
) {
  final timestamp = DateTime.utc(
    2026,
    1,
    index + 1,
  );

  return SwingPoint(
    index: index,
    timestamp: timestamp,
    confirmedAt: timestamp.add(const Duration(days: 1)),
    price: price,
    type: SwingType.low,
    classification: classification,
  );
}

void main() {
  const engine = AtlasMarketStructureEngine();

  test('classifies HH plus HL as bullish', () {
    final result = engine.analyze([
      swingHigh(1, 100, SwingClassification.first),
      swingLow(2, 90, SwingClassification.first),
      swingHigh(3, 110, SwingClassification.higherHigh),
      swingLow(4, 95, SwingClassification.higherLow),
    ]);

    expect(result.state, MarketStructureState.bullish);
    expect(result.latestHigh?.price, 110);
    expect(result.latestLow?.price, 95);
  });

  test('classifies LH plus LL as bearish', () {
    final result = engine.analyze([
      swingHigh(1, 110, SwingClassification.first),
      swingLow(2, 100, SwingClassification.first),
      swingHigh(3, 105, SwingClassification.lowerHigh),
      swingLow(4, 90, SwingClassification.lowerLow),
    ]);

    expect(result.state, MarketStructureState.bearish);
    expect(result.latestHigh?.price, 105);
    expect(result.latestLow?.price, 90);
  });

  test('classifies mixed structure correctly', () {
    final result = engine.analyze([
      swingHigh(1, 100, SwingClassification.first),
      swingLow(2, 90, SwingClassification.first),
      swingHigh(3, 110, SwingClassification.higherHigh),
      swingLow(4, 85, SwingClassification.lowerLow),
    ]);

    expect(result.state, MarketStructureState.mixed);
  });

  test('requires two highs and two lows', () {
    final result = engine.analyze([
      swingHigh(1, 100, SwingClassification.first),
      swingLow(2, 90, SwingClassification.first),
    ]);

    expect(
      result.state,
      MarketStructureState.insufficient,
    );
  });

  test('preserves latest and previous swing points', () {
    final result = engine.analyze([
      swingHigh(1, 100, SwingClassification.first),
      swingLow(2, 90, SwingClassification.first),
      swingHigh(3, 110, SwingClassification.higherHigh),
      swingLow(4, 95, SwingClassification.higherLow),
    ]);

    expect(result.previousHigh?.price, 100);
    expect(result.latestHigh?.price, 110);
    expect(result.previousLow?.price, 90);
    expect(result.latestLow?.price, 95);
  });
}
