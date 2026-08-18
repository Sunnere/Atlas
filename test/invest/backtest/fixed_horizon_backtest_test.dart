import 'package:test/test.dart';

import '../../../lib/core/contracts/signal_contract.dart';
import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/backtest/fixed_horizon_backtest.dart';

void main() {
  test('compounds a fixed 20-day short position correctly', () {
    const backtest = AtlasFixedHorizonBacktest(
      config: FixedHorizonBacktestConfig(
        horizonDays: 2,
        transactionCostPercent: 0.05,
        slippagePercent: 0.02,
        initialCapital: 100000.0,
      ),
      signalEvaluator: alwaysSell,
    );

    final observations = [
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 1),
        priceChangePercent: 0.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 2),
        priceChangePercent: -2.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 3),
        priceChangePercent: -1.0,
        volumeRatio: 1.0,
      ),
    ];

    final result = backtest.run(observations);

    expect(result.signalCount, 1);
    expect(result.tradeCount, 1);
    expect(result.winningTrades, 1);
    expect(result.losingTrades, 0);

    // Short growth:
    // (1 - (-2%)) * (1 - (-1%))
    // = 1.02 * 1.01
    // = 1.0302
    //
    // Cost:
    // 0.05% + 0.02% = 0.07%
    // Final multiplier:
    // 1.0302 * 0.9993
    // = 1.02947886
    //
    // Final capital:
    // 102947.886
    expect(
      result.finalCapital,
      closeTo(102947.886, 0.001),
    );

    expect(
      result.strategyReturnPercent,
      closeTo(2.947886, 0.0001),
    );

    expect(
      result.totalCostsPercent,
      closeTo(0.07, 0.0001),
    );

    expect(result.winRate, 1.0);
    expect(result.maxDrawdownPercent, 0.0);
  });

  test('does not overlap fixed-horizon trades', () {
    const backtest = AtlasFixedHorizonBacktest(
      config: FixedHorizonBacktestConfig(
        horizonDays: 2,
        initialCapital: 100000.0,
      ),
      signalEvaluator: alwaysSell,
    );

    final observations = List.generate(
      7,
      (index) => MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(
          2026,
          1,
          index + 1,
        ),
        priceChangePercent: -1.0,
        volumeRatio: 1.0,
      ),
    );

    final result = backtest.run(observations);

    // First trade: index 0 -> 2.
    // Next eligible signal: index 2 -> 4.
    // Next eligible signal: index 4 -> 6.
    expect(result.signalCount, 3);
    expect(result.tradeCount, 3);
  });

  test('can lose capital but never produce below -100 percent return',
      () {
    const backtest = AtlasFixedHorizonBacktest(
      config: FixedHorizonBacktestConfig(
        horizonDays: 2,
        initialCapital: 100000.0,
      ),
      signalEvaluator: alwaysSell,
    );

    final observations = [
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 1),
        priceChangePercent: 0.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 2),
        priceChangePercent: 50.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 3),
        priceChangePercent: 50.0,
        volumeRatio: 1.0,
      ),
    ];

    final result = backtest.run(observations);

    expect(result.finalCapital, greaterThan(0));
    expect(
      result.strategyReturnPercent,
      greaterThanOrEqualTo(-100.0),
    );
  });
}

SignalDirection alwaysSell(
  MarketObservation observation,
) {
  return SignalDirection.sell;
}
