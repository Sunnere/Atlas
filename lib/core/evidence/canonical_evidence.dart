import 'dart:convert';

import 'evidence.dart';

class CanonicalEvidence {
  CanonicalEvidence._(this._value);

  factory CanonicalEvidence.from(Evidence evidence) {
    return CanonicalEvidence._(
      <String, Object?>{
        'snapshotId': evidence.snapshotId,
        'source': evidence.source,
        'location': evidence.location,
        'observation': evidence.observation,
        'type': evidence.type.name,
        'confidence': evidence.confidence.name,
      },
    );
  }

  final Map<String, Object?> _value;

  String get canonicalJson => jsonEncode(_value);
}
