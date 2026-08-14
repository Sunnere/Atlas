import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/regime_analysis.dart';

void main() {
  test('classifies regime using only prior observations', () {
    const analyzer = AtlasRegimeAnalyzer(
      lookbackDays: 2,
    );

    final observations = [
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 1),
        priceChangePercent: 2.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 2),
        priceChangePercent: 3.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 3),
        priceChangePercent: -1.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 4),
        priceChangePercent: 1.0,
        volumeRatio: 1.0,
      ),
    ];

    expect(
      analyzer.regimeAt(observations, 2),
      MarketRegime.bull,
    );

    expect(
      analyzer.regimeAt(observations, 3),
      MarketRegime.bull,
    );
  });

  test('produces regime and horizon results', () {
    const analyzer = AtlasRegimeAnalyzer(
      lookbackDays: 2,
    );

    final observations = List.generate(
      8,
      (index) => MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, index + 1),
        priceChangePercent: index.isEven ? 2.0 : 1.0,
        volumeRatio: 1.0,
      ),
    );

    final results = analyzer.analyze(
      observations,
      horizons: [1],
    );

    expect(results, isNotEmpty);
    expect(
      results.every(
        (result) => result.horizonDays == 1,
      ),
      isTrue,
    );
  });
}
