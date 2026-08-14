import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/oos_regime_analysis.dart';
import '../../../lib/invest/analysis/regime_analysis.dart';

void main() {
  test('classifies OOS observations using prior history only', () {
    const analyzer = AtlasOosRegimeAnalyzer(
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
  });

  test('returns train and test regime buckets', () {
    const analyzer = AtlasOosRegimeAnalyzer(
      lookbackDays: 2,
    );

    final observations = List.generate(
      12,
      (index) => MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(
          2026,
          1,
          index + 1,
        ),
        priceChangePercent: 1.0,
        volumeRatio: 1.0,
      ),
    );

    final results = analyzer.analyze(
      observations,
      splitDate: DateTime.utc(2026, 1, 7),
      horizons: [1],
    );

    expect(results, hasLength(4));

    expect(
      results.every(
        (result) =>
            result.dataset == 'TRAIN' ||
            result.dataset == 'TEST',
      ),
      isTrue,
    );

    expect(
      results.every(
        (result) =>
            result.regime == MarketRegime.bull ||
            result.regime == MarketRegime.bear,
      ),
      isTrue,
    );
  });
}
