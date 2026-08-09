import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';

class AtlasSignalEngine {
  const AtlasSignalEngine();

  AtlasSignal evaluate(MarketObservation observation) {
    final bool bullishMomentum =
        observation.priceChangePercent >= 2.0;

    final bool bearishMomentum =
        observation.priceChangePercent <= -2.0;

    final bool volumeConfirmed =
        observation.volumeRatio >= 1.5;

    if (bullishMomentum && volumeConfirmed) {
      return AtlasSignal(
        instrument: observation.instrument,
        timestamp: observation.timestamp,
        direction: SignalDirection.buy,
        strength: SignalStrength.high,
        evidence: [
          SignalEvidence(
            type: 'momentum',
            description:
                'Positive price momentum detected.',
            value: observation.priceChangePercent,
          ),
          SignalEvidence(
            type: 'volume',
            description:
                'Volume is above the baseline.',
            value: observation.volumeRatio,
          ),
        ],
        risk: SignalRisk.moderate,
        invalidation:
            'Positive momentum or volume confirmation disappears.',
        explanation:
            'Positive momentum is supported by elevated volume.',
        sources: const ['controlled-observation'],
      );
    }

    if (bearishMomentum && volumeConfirmed) {
      return AtlasSignal(
        instrument: observation.instrument,
        timestamp: observation.timestamp,
        direction: SignalDirection.sell,
        strength: SignalStrength.high,
        evidence: [
          SignalEvidence(
            type: 'momentum',
            description:
                'Negative price momentum detected.',
            value: observation.priceChangePercent,
          ),
          SignalEvidence(
            type: 'volume',
            description:
                'Volume is above the baseline.',
            value: observation.volumeRatio,
          ),
        ],
        risk: SignalRisk.moderate,
        invalidation:
            'Negative momentum or volume confirmation disappears.',
        explanation:
            'Negative momentum is supported by elevated volume.',
        sources: const ['controlled-observation'],
      );
    }

    return AtlasSignal(
      instrument: observation.instrument,
      timestamp: observation.timestamp,
      direction: SignalDirection.wait,
      strength: SignalStrength.low,
      evidence: [
        SignalEvidence(
          type: 'market',
          description:
              'Current conditions do not meet the signal threshold.',
        ),
      ],
      risk: SignalRisk.low,
      invalidation:
          'Signal conditions change materially.',
      explanation:
          'Available observations do not provide sufficient confirmation.',
      sources: const ['controlled-observation'],
    );
  }
}
