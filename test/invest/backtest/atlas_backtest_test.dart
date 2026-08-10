import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/backtest/atlas_backtest.dart';

void main() {
  group('Atlas Backtest', () {
    test('evaluates historical signal outcomes', () {
      final backtest = AtlasBacktest();

      final result = backtest.run([
        BacktestCase(
          observation: MarketObservation(
            instrument: 'NVIDIA',
            timestamp: DateTime.utc(2026, 1, 1),
            priceChangePercent: 3.0,
            volumeRatio: 2.0,
          ),
          futurePriceChangePercent: 4.0,
        ),
        BacktestCase(
          observation: MarketObservation(
            instrument: 'NVIDIA',
            timestamp: DateTime.utc(2026, 1, 2),
            priceChangePercent: -3.0,
            volumeRatio: 2.0,
          ),
          futurePriceChangePercent: -2.0,
        ),
        BacktestCase(
          observation: MarketObservation(
            instrument: 'NVIDIA',
            timestamp: DateTime.utc(2026, 1, 3),
            priceChangePercent: 0.5,
            volumeRatio: 1.0,
          ),
          futurePriceChangePercent: 1.0,
        ),
      ]);

      expect(result.totalSignals, 2);
      expect(result.correctSignals, 2);
      expect(result.incorrectSignals, 0);
      expect(result.waitSignals, 1);
      expect(result.hitRate, 1.0);
    });

    test('counts incorrect directional signals', () {
      final backtest = AtlasBacktest();

      final result = backtest.run([
        BacktestCase(
          observation: MarketObservation(
            instrument: 'NVIDIA',
            timestamp: DateTime.utc(2026, 1, 1),
            priceChangePercent: 3.0,
            volumeRatio: 2.0,
          ),
          futurePriceChangePercent: -2.0,
        ),
      ]);

      expect(result.totalSignals, 1);
      expect(result.correctSignals, 0);
      expect(result.incorrectSignals, 1);
      expect(result.hitRate, 0.0);
    });
  });
}
