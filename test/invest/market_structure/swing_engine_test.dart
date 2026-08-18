import 'package:test/test.dart';

import '../../../lib/invest/market_structure/market_bar.dart';
import '../../../lib/invest/market_structure/swing_engine.dart';

MarketBar bar(
  int day,
  double high,
  double low,
) {
  return MarketBar(
    instrument: 'NVDA',
    timestamp: DateTime.utc(2026, 1, day),
    open: (high + low) / 2,
    high: high,
    low: low,
    close: (high + low) / 2,
    volume: 1000,
  );
}

void main() {
  group('AtlasSwingEngine', () {
    test('detects a swing high with strength 2', () {
      const engine = AtlasSwingEngine(strength: 2);

      final bars = [
        bar(1, 10, 8),
        bar(2, 11, 9),
        bar(3, 15, 10),
        bar(4, 12, 9),
        bar(5, 11, 8),
      ];

      final result = engine.detect(bars);

      expect(result.length, 1);
      expect(result[0].index, 2);
      expect(result[0].type, SwingType.high);
      expect(result[0].price, 15);
      expect(
        result[0].classification,
        SwingClassification.first,
      );

      // Pivot on day 3 becomes known on day 5.
      expect(
        result[0].confirmedAt,
        DateTime.utc(2026, 1, 5),
      );
    });

    test('detects a swing low with strength 2', () {
      const engine = AtlasSwingEngine(strength: 2);

      final bars = [
        bar(1, 15, 12),
        bar(2, 14, 10),
        bar(3, 13, 5),
        bar(4, 14, 9),
        bar(5, 15, 11),
      ];

      final result = engine.detect(bars);

      expect(result.length, 1);
      expect(result[0].index, 2);
      expect(result[0].type, SwingType.low);
      expect(result[0].price, 5);
      expect(
        result[0].classification,
        SwingClassification.first,
      );
      expect(
        result[0].confirmedAt,
        DateTime.utc(2026, 1, 5),
      );
    });

    test('classifies higher highs and higher lows', () {
      const engine = AtlasSwingEngine(strength: 1);

      final bars = [
        bar(1, 10, 7),
        bar(2, 15, 9),
        bar(3, 11, 8),
        bar(4, 13, 10),
        bar(5, 16, 12),
        bar(6, 12, 9),
        bar(7, 17, 13),
      ];

      final result = engine.detect(bars);

      final highs = result
          .where((point) => point.type == SwingType.high)
          .toList();

      final lows = result
          .where((point) => point.type == SwingType.low)
          .toList();

      expect(highs.length, 2);
      expect(lows.length, 2);

      expect(
        highs[1].classification,
        SwingClassification.higherHigh,
      );

      expect(
        lows[1].classification,
        SwingClassification.higherLow,
      );
    });

    test('classifies lower highs and lower lows', () {
      const engine = AtlasSwingEngine(strength: 1);

      final bars = [
        bar(1, 20, 15),
        bar(2, 18, 12),
        bar(3, 16, 10),
        bar(4, 17, 11),
        bar(5, 14, 8),
        bar(6, 15, 9),
        bar(7, 12, 6),
      ];

      final result = engine.detect(bars);

      final highs = result
          .where((point) => point.type == SwingType.high)
          .toList();

      final lows = result
          .where((point) => point.type == SwingType.low)
          .toList();

      expect(highs.length, 2);
      expect(lows.length, 2);

      expect(
        highs[1].classification,
        SwingClassification.lowerHigh,
      );

      expect(
        lows[1].classification,
        SwingClassification.lowerLow,
      );
    });

    test('does not detect a pivot before enough bars exist', () {
      const engine = AtlasSwingEngine(strength: 2);

      final bars = [
        bar(1, 10, 8),
        bar(2, 15, 9),
        bar(3, 11, 8),
      ];

      final result = engine.detect(bars);

      expect(result, isEmpty);
    });

    test('does not detect a tied neighbouring high', () {
      const engine = AtlasSwingEngine(strength: 1);

      final bars = [
        bar(1, 10, 8),
        bar(2, 15, 9),
        bar(3, 15, 8),
      ];

      final result = engine.detect(bars);

      expect(result, isEmpty);
    });
  });
}
