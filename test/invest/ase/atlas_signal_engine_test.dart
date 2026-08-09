import 'package:test/test.dart';

import '../../../lib/core/observations/market_observation.dart';
import '../../../lib/core/contracts/signal_contract.dart';
import '../../../lib/invest/ase/atlas_signal_engine.dart';

void main() {
  const engine = AtlasSignalEngine();

  group('Atlas Signal Engine', () {
    test('produces BUY when momentum and volume are confirmed', () {
      final observation = MarketObservation(
        instrument: 'NVIDIA',
        timestamp: DateTime.utc(2026, 8, 9, 8, 0),
        priceChangePercent: 3.2,
        volumeRatio: 2.1,
      );

      final signal = engine.evaluate(observation);

      expect(signal.direction, SignalDirection.buy);
      expect(signal.strength, SignalStrength.high);
      expect(signal.risk, SignalRisk.moderate);
      expect(signal.evidence, hasLength(2));
      expect(signal.explanation, isNotEmpty);
    });

    test('produces SELL when negative momentum and volume are confirmed', () {
      final observation = MarketObservation(
        instrument: 'NVIDIA',
        timestamp: DateTime.utc(2026, 8, 9, 8, 0),
        priceChangePercent: -3.2,
        volumeRatio: 2.0,
      );

      final signal = engine.evaluate(observation);

      expect(signal.direction, SignalDirection.sell);
      expect(signal.strength, SignalStrength.high);
    });

    test('produces WAIT when confirmation is insufficient', () {
      final observation = MarketObservation(
        instrument: 'NVIDIA',
        timestamp: DateTime.utc(2026, 8, 9, 8, 0),
        priceChangePercent: 1.0,
        volumeRatio: 1.1,
      );

      final signal = engine.evaluate(observation);

      expect(signal.direction, SignalDirection.wait);
      expect(signal.strength, SignalStrength.low);
    });
  });
}
