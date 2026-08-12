import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/backtest/economic_backtest.dart';

void main() {
  group('AtlasEconomicBacktest', () {
    test('compares strategy against buy and hold', () {
      const backtest = AtlasEconomicBacktest(
        config: EconomicBacktestConfig(
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
          priceChangePercent: -1.0,
          volumeRatio: 1.0,
        ),
      ];

      final result = backtest.run(observations);

      expect(result.signalCount, 2);
      expect(result.tradeCount, 2);

      expect(
        result.strategyReturnPercent,
        closeTo(0.98, 0.0001),
      );

      expect(
        result.buyAndHoldReturnPercent,
        closeTo(0.98, 0.0001),
      );

      expect(result.totalCostsPercent, 0);
    });

    test('includes transaction costs and slippage', () {
      const backtest = AtlasEconomicBacktest(
        config: EconomicBacktestConfig(
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
      ];

      final result = backtest.run(observations);

      expect(result.signalCount, 1);
      expect(result.totalCostsPercent, closeTo(0.07, 0.0001));

      expect(
        result.strategyReturnPercent,
        closeTo(1.93, 0.0001),
      );
    });
  });
}
