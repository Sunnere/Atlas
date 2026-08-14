import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/walk_forward_economic_analysis.dart';

void main() {
  test('counts observations inside the test fold', () {
    const analyzer = AtlasWalkForwardEconomicAnalyzer(
      costPerTradePercent: 0.07,
    );

    final observations = [
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2025, 12, 31),
        priceChangePercent: 100.0,
        volumeRatio: 1.0,
      ),
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 1),
        priceChangePercent: -3.0,
        volumeRatio: 2.0,
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
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 5),
        priceChangePercent: 100.0,
        volumeRatio: 1.0,
      ),
    ];

    final result = analyzer.analyzeFold(
      observations,
      fold: 'TEST',
      testStart: DateTime.utc(2026, 1, 1),
      testEnd: DateTime.utc(2026, 1, 4),
      horizonDays: 2,
    );

    expect(result.observations, 2);
    expect(result.trades, 1);

    expect(
      result.grossReturnPercent,
      closeTo(3.02, 0.0001),
    );

    expect(
      result.totalCostsPercent,
      closeTo(0.07, 0.0001),
    );

    expect(
      result.netReturnPercent,
      closeTo(2.95, 0.0001),
    );

    expect(result.winRate, 1.0);
  });
}
