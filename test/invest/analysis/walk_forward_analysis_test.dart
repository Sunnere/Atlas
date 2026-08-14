import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/walk_forward_analysis.dart';

void main() {
  test('analyzes a chronological test fold', () {
    const analyzer = AtlasWalkForwardAnalyzer();

    final observations = List.generate(
      10,
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

    final result = analyzer.analyzeFold(
      observations,
      fold: WalkForwardFold(
        name: 'FOLD-1',
        testStart: DateTime.utc(2026, 1, 5),
        testEnd: DateTime.utc(2026, 1, 9),
      ),
      horizonDays: 1,
    );

    expect(result.fold, 'FOLD-1');
    expect(result.horizonDays, 1);
    expect(result.observations, 4);
  });

  test('returns one result per fold and horizon', () {
    const analyzer = AtlasWalkForwardAnalyzer();

    final observations = List.generate(
      15,
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
      folds: [
        WalkForwardFold(
          name: 'FOLD-1',
          testStart: DateTime.utc(2026, 1, 5),
          testEnd: DateTime.utc(2026, 1, 8),
        ),
        WalkForwardFold(
          name: 'FOLD-2',
          testStart: DateTime.utc(2026, 1, 9),
          testEnd: DateTime.utc(2026, 1, 12),
        ),
      ],
      horizons: [1, 3],
    );

    expect(results, hasLength(4));
  });
}
