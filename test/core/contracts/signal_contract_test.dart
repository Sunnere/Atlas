import 'package:test/test.dart';

import '../../../lib/core/contracts/signal_contract.dart';

void main() {
  group('AtlasSignal', () {
    test('creates a valid signal contract', () {
      final signal = AtlasSignal(
        instrument: 'NVIDIA',
        timestamp: DateTime.utc(2026, 8, 8, 20, 0),
        direction: SignalDirection.buy,
        strength: SignalStrength.high,
        evidence: const [
          SignalEvidence(
            type: 'momentum',
            description: 'Positive momentum detected',
          ),
          SignalEvidence(
            type: 'volume',
            description: 'Volume above historical average',
            value: 2.1,
          ),
        ],
        risk: SignalRisk.moderate,
        invalidation: 'Momentum reverses and volume confirmation disappears.',
        explanation:
            'Multiple independent observations support the current signal.',
        sources: ['test-market-feed'],
      );

      expect(signal.instrument, 'NVIDIA');
      expect(signal.direction, SignalDirection.buy);
      expect(signal.strength, SignalStrength.high);
      expect(signal.risk, SignalRisk.moderate);
      expect(signal.evidence, hasLength(2));
      expect(signal.invalidation, isNotEmpty);
      expect(signal.explanation, isNotEmpty);
      expect(signal.sources, contains('test-market-feed'));
    });

    test('supports BUY, SELL and WAIT directions', () {
      expect(SignalDirection.values, contains(SignalDirection.buy));
      expect(SignalDirection.values, contains(SignalDirection.sell));
      expect(SignalDirection.values, contains(SignalDirection.wait));
    });
  });
}
