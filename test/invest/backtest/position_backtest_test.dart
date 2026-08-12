import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/backtest/position_backtest.dart';

void main() {
  group('AtlasPositionBacktest', () {
    test('does not create a new trade for repeated BUY signals', () {
      const backtest = AtlasPositionBacktest(
        config: PositionBacktestConfig(
          transactionCostPercent: 0,
          slippagePercent: 0,
        ),
      );

      final observations = [
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 1),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 2),
          priceChangePercent: 2.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 3),
          priceChangePercent: 1.0,
          volumeRatio: 2.0,
        ),
      ];

      final result = backtest.run(observations);

      expect(result.signalCount, 2);
      expect(result.tradeCount, 1);
      expect(result.longDays, 2);
      expect(result.shortDays, 0);
      expect(result.flatDays, 0);
    });

    test('WAIT holds the current position', () {
      const backtest = AtlasPositionBacktest(
        config: PositionBacktestConfig(
          transactionCostPercent: 0,
          slippagePercent: 0,
        ),
      );

      final observations = [
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 1),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 2),
          priceChangePercent: 1.0,
          volumeRatio: 1.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 3),
          priceChangePercent: 1.0,
          volumeRatio: 1.0,
        ),
      ];

      final result = backtest.run(observations);

      expect(result.tradeCount, 1);
      expect(result.longDays, 2);
      expect(result.flatDays, 0);
    });

    test('reversal creates one position change', () {
      const backtest = AtlasPositionBacktest(
        config: PositionBacktestConfig(
          transactionCostPercent: 0,
          slippagePercent: 0,
        ),
      );

      final observations = [
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 1),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 2),
          priceChangePercent: -3.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 3),
          priceChangePercent: -1.0,
          volumeRatio: 1.0,
        ),
      ];

      final result = backtest.run(observations);

      expect(result.signalCount, 2);
      expect(result.tradeCount, 2);
      expect(result.longDays, 1);
      expect(result.shortDays, 1);
    });

    test('applies costs only when position changes', () {
      const backtest = AtlasPositionBacktest(
        config: PositionBacktestConfig(
          transactionCostPercent: 0.05,
          slippagePercent: 0.02,
        ),
      );

      final observations = [
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 1),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 2),
          priceChangePercent: 2.0,
          volumeRatio: 2.0,
        ),
        MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 3),
          priceChangePercent: 1.0,
          volumeRatio: 2.0,
        ),
      ];

      final result = backtest.run(observations);

      expect(result.signalCount, 2);
      expect(result.tradeCount, 1);
      expect(result.totalCostsPercent, closeTo(0.07, 0.0001));
    });
  });
}
