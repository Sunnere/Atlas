import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/forward_horizon_analysis.dart';

void main() {
  test('uses compounded forward returns', () {
    const analyzer = AtlasForwardHorizonAnalyzer();

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

    final results = analyzer.analyze(
      observations,
      horizons: [1, 2],
    );

    expect(results, hasLength(2));

    expect(results[0].horizonDays, 1);
    expect(results[0].buySignals, 1);

    expect(
      results[0].buyAverageReturnPercent,
      closeTo(2.0, 0.0001),
    );

    expect(results[1].horizonDays, 2);
    expect(results[1].buySignals, 1);

    expect(
      results[1].buyAverageReturnPercent,
      closeTo(3.02, 0.0001),
    );
  });
}
