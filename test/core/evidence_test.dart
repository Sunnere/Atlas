import 'package:atlas/core/evidence/evidence.dart';
import 'package:atlas/core/evidence/evidence_confidence.dart';
import 'package:atlas/core/evidence/evidence_type.dart';
import 'package:test/test.dart';

void main() {
  test('stores all evidence fields', () {
    const id = 'evidence-001';
    const snapshotId = 'abc123';
    const source = 'repository';
    const location = 'lib/core/example.dart';
    const observation = 'Repository contains a Dart model.';

    final evidence = Evidence(
      id: id,
      snapshotId: snapshotId,
      source: source,
      location: location,
      observation: observation,
      type: EvidenceType.structural,
      confidence: EvidenceConfidence.verified,
    );

    expect(evidence.id, id);
    expect(evidence.snapshotId, snapshotId);
    expect(evidence.source, source);
    expect(evidence.location, location);
    expect(evidence.observation, observation);
    expect(evidence.type, EvidenceType.structural);
    expect(evidence.confidence, EvidenceConfidence.verified);
  });

  test('rejects empty evidence id', () {
    expect(
      () => Evidence(
        id: '',
        snapshotId: 'snapshot-001',
        source: 'repository',
        location: 'lib/example.dart',
        observation: 'Observed.',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });

  test('rejects empty snapshot id', () {
    expect(
      () => Evidence(
        id: 'evidence-001',
        snapshotId: '',
        source: 'repository',
        location: 'lib/example.dart',
        observation: 'Observed.',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });

  test('rejects empty source', () {
    expect(
      () => Evidence(
        id: 'evidence-001',
        snapshotId: 'snapshot-001',
        source: '',
        location: 'lib/example.dart',
        observation: 'Observed.',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });

  test('rejects empty location', () {
    expect(
      () => Evidence(
        id: 'evidence-001',
        snapshotId: 'snapshot-001',
        source: 'repository',
        location: '',
        observation: 'Observed.',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });

  test('rejects empty observation', () {
    expect(
      () => Evidence(
        id: 'evidence-001',
        snapshotId: 'snapshot-001',
        source: 'repository',
        location: 'lib/example.dart',
        observation: '',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });

  test('supports all evidence types', () {
    expect(EvidenceType.values, contains(EvidenceType.structural));
    expect(EvidenceType.values, contains(EvidenceType.behavioral));
    expect(EvidenceType.values, contains(EvidenceType.configuration));
    expect(EvidenceType.values, contains(EvidenceType.external));
    expect(EvidenceType.values, contains(EvidenceType.document));
  });

  test('supports all confidence levels', () {
    expect(
      EvidenceConfidence.values,
      contains(EvidenceConfidence.verified),
    );
    expect(
      EvidenceConfidence.values,
      contains(EvidenceConfidence.inferred),
    );
    expect(
      EvidenceConfidence.values,
      contains(EvidenceConfidence.assumed),
    );
    expect(
      EvidenceConfidence.values,
      contains(EvidenceConfidence.requiresReview),
    );
  });

  test('whitespace-only values are rejected', () {
    expect(
      () => Evidence(
        id: 'evidence-001',
        snapshotId: 'snapshot-001',
        source: 'repository',
        location: 'lib/example.dart',
        observation: '   ',
        type: EvidenceType.structural,
        confidence: EvidenceConfidence.verified,
      ),
      throwsArgumentError,
    );
  });
}
