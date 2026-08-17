import 'evidence_confidence.dart';
import 'evidence_type.dart';

class Evidence {
  factory Evidence({
    required String id,
    required String snapshotId,
    required String source,
    required String location,
    required String observation,
    required EvidenceType type,
    required EvidenceConfidence confidence,
  }) {
    _requireNonEmpty('id', id);
    _requireNonEmpty('snapshotId', snapshotId);
    _requireNonEmpty('source', source);
    _requireNonEmpty('location', location);
    _requireNonEmpty('observation', observation);

    return Evidence._(
      id: id,
      snapshotId: snapshotId,
      source: source,
      location: location,
      observation: observation,
      type: type,
      confidence: confidence,
    );
  }

  const Evidence._({
    required this.id,
    required this.snapshotId,
    required this.source,
    required this.location,
    required this.observation,
    required this.type,
    required this.confidence,
  });

  final String id;
  final String snapshotId;
  final String source;
  final String location;
  final String observation;
  final EvidenceType type;
  final EvidenceConfidence confidence;

  static void _requireNonEmpty(String field, String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(
        value,
        field,
        'must not be empty',
      );
    }
  }

  @override
  String toString() {
    return 'Evidence('
        'id: $id, '
        'snapshotId: $snapshotId, '
        'type: $type, '
        'confidence: $confidence'
        ')';
  }
}
