import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/invest/analysis/forward_return_calculator.dart';

void main() {
  const calculator = ForwardReturnCalculator();

  test('calculates compounded forward return', () {
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
    ];

    expect(
      calculator.calculate(
        observations,
        startIndex: 0,
        horizon: 1,
      ),
      closeTo(2.0, 0.0001),
    );

    expect(
      calculator.calculate(
        observations,
        startIndex: 0,
        horizon: 2,
      ),
      closeTo(3.02, 0.0001),
    );
  });

  test('rejects a horizon beyond available observations', () {
    final observations = [
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.utc(2026, 1, 1),
        priceChangePercent: 3.0,
        volumeRatio: 2.0,
      ),
    ];

    expect(
      () => calculator.calculate(
        observations,
        startIndex: 0,
        horizon: 1,
      ),
      throwsRangeError,
    );
  });
}
