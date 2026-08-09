enum SignalDirection {
  buy,
  sell,
  wait,
}

enum SignalStrength {
  low,
  medium,
  high,
}

enum SignalRisk {
  low,
  moderate,
  high,
}

class SignalEvidence {
  final String type;
  final String description;
  final double? value;
  final String? source;

  const SignalEvidence({
    required this.type,
    required this.description,
    this.value,
    this.source,
  });
}

class AtlasSignal {
  final String instrument;
  final DateTime timestamp;
  final SignalDirection direction;
  final SignalStrength strength;
  final List<SignalEvidence> evidence;
  final SignalRisk risk;
  final String invalidation;
  final String explanation;
  final List<String> sources;

  AtlasSignal({
    required this.instrument,
    required this.timestamp,
    required this.direction,
    required this.strength,
    required List<SignalEvidence> evidence,
    required this.risk,
    required this.invalidation,
    required this.explanation,
    required List<String> sources,
  })  : evidence = List.unmodifiable(evidence),
        sources = List.unmodifiable(sources);
}
