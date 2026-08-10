import 'package:test/test.dart';

import '../../../lib/invest/data/historical_market_data.dart';
import '../../../lib/invest/ase/atlas_signal_engine.dart';
import '../../../lib/invest/backtest/atlas_backtest.dart';

void main() {
  test('runs historical data through the complete Atlas signal pipeline', () {
    const adapter = HistoricalMarketDataAdapter();
    const engine = AtlasSignalEngine();
    const backtest = AtlasBacktest();

    final observations = adapter.fromRows([
      {
        'instrument': 'NVDA',
        'timestamp': '2026-01-05T00:00:00Z',
        'priceChangePercent': '3.2',
        'volumeRatio': '2.1',
      },
      {
        'instrument': 'NVDA',
        'timestamp': '2026-01-06T00:00:00Z',
        'priceChangePercent': '-3.0',
        'volumeRatio': '2.0',
      },
      {
        'instrument': 'NVDA',
        'timestamp': '2026-01-07T00:00:00Z',
        'priceChangePercent': '0.4',
        'volumeRatio': '1.1',
      },
    ]);

    final cases = [
      BacktestCase(
        observation: observations[0],
        futurePriceChangePercent: 4.0,
      ),
      BacktestCase(
        observation: observations[1],
        futurePriceChangePercent: -2.0,
      ),
      BacktestCase(
        observation: observations[2],
        futurePriceChangePercent: 0.5,
      ),
    ];

    final result = backtest.run(cases);

    expect(observations, hasLength(3));
    expect(result.totalSignals, 2);
    expect(result.correctSignals, 2);
    expect(result.incorrectSignals, 0);
    expect(result.waitSignals, 1);
    expect(result.hitRate, 1.0);

    // Prove ASE is still the component producing the decisions.
    expect(
      engine.evaluate(observations[0]).direction.name,
      'buy',
    );
    expect(
      engine.evaluate(observations[1]).direction.name,
      'sell',
    );
  });
}
