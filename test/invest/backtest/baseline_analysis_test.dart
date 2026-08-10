import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/backtest/atlas_backtest.dart';
import '../../../lib/invest/backtest/baseline_analysis.dart';

void main() {
  test('analyzes BUY and SELL signals separately', () {
    const analyzer = AtlasBaselineAnalyzer();

    final cases = [
      BacktestCase(
        observation: MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 1),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        futurePriceChangePercent: 2.0,
      ),
      BacktestCase(
        observation: MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 2),
          priceChangePercent: 3.0,
          volumeRatio: 2.0,
        ),
        futurePriceChangePercent: -1.0,
      ),
      BacktestCase(
        observation: MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 3),
          priceChangePercent: -3.0,
          volumeRatio: 2.0,
        ),
        futurePriceChangePercent: -2.0,
      ),
      BacktestCase(
        observation: MarketObservation(
          instrument: 'NVDA',
          timestamp: DateTime.utc(2026, 1, 4),
          priceChangePercent: 0.5,
          volumeRatio: 1.0,
        ),
        futurePriceChangePercent: 1.0,
      ),
    ];

    final result = analyzer.analyze(cases);

    expect(result.buy.count, 2);
    expect(result.buy.correct, 1);
    expect(result.buy.incorrect, 1);
    expect(result.buy.hitRate, 0.5);
    expect(result.buy.averageForwardReturnPercent, 0.5);

    expect(result.sell.count, 1);
    expect(result.sell.correct, 1);
    expect(result.sell.incorrect, 0);
    expect(result.sell.hitRate, 1.0);
    expect(result.sell.averageForwardReturnPercent, 2.0);

    expect(result.waitSignals, 1);
  });
}
