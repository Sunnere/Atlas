import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/out_of_sample_analysis.dart';

void main() {
  test('calculates out-of-sample conditional uplift', () {
    const analyzer = AtlasOutOfSampleAnalyzer();

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
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 3),
        priceChangePercent: 1.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 4),
        priceChangePercent: 4.0,
        volumeRatio: 1.0,
      ),
    ];

    final result = analyzer.analyze(
      observations,
      dataset: 'TEST',
      horizons: [1],
    );

    expect(result.dataset, 'TEST');
    expect(result.observations, 4);
    expect(result.buySignals, 1);
    expect(result.nonBuySignals, 2);

    expect(
      result.buyAverageReturnPercent,
      closeTo(2.0, 0.0001),
    );

    expect(
      result.nonBuyAverageReturnPercent,
      closeTo(2.5, 0.0001),
    );

    expect(
      result.buyUpliftPercent,
      closeTo(-0.5, 0.0001),
    );
  });
}
