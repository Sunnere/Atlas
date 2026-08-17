import 'package:atlas/core/evidence/canonical_evidence.dart';
import 'package:atlas/core/evidence/evidence.dart';
import 'package:atlas/core/evidence/evidence_confidence.dart';
import 'package:atlas/core/evidence/evidence_identity.dart';
import 'package:atlas/core/evidence/evidence_type.dart';
import 'package:test/test.dart';

Evidence buildEvidence({
  String id = 'record-001',
  String snapshotId = 'snapshot-001',
  String source = 'repository',
  String location = 'lib/example.dart',
  String observation = 'Observed repository structure.',
  EvidenceType type = EvidenceType.structural,
  EvidenceConfidence confidence = EvidenceConfidence.verified,
}) {
  return Evidence(
    id: id,
    snapshotId: snapshotId,
    source: source,
    location: location,
    observation: observation,
    type: type,
    confidence: confidence,
  );
}

void main() {
  test('uses sha256', () {
    final identity = EvidenceIdentity.from(
      CanonicalEvidence.from(buildEvidence()),
    );

    expect(identity.algorithm, 'sha256');
  });

  test('produces a 64-character hexadecimal digest', () {
    final identity = EvidenceIdentity.from(
      CanonicalEvidence.from(buildEvidence()),
    );

    expect(identity.value, hasLength(64));
    expect(
      RegExp(r'^[0-9a-f]{64}$').hasMatch(identity.value),
      isTrue,
    );
  });

  test('same evidence content produces the same identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(id: 'record-a'),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(id: 'record-b'),
      ),
    );

    expect(first.value, second.value);
  });

  test('different snapshot produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(snapshotId: 'snapshot-a'),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(snapshotId: 'snapshot-b'),
      ),
    );

    expect(first.value, isNot(second.value));
  });

  test('different observation produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(observation: 'Observation A'),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(observation: 'Observation B'),
      ),
    );

    expect(first.value, isNot(second.value));
  });

  test('different source produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(source: 'repository'),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(source: 'document'),
      ),
    );

    expect(first.value, isNot(second.value));
  });

  test('different location produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(location: 'lib/a.dart'),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(location: 'lib/b.dart'),
      ),
    );

    expect(first.value, isNot(second.value));
  });

  test('different type produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(type: EvidenceType.structural),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(type: EvidenceType.document),
      ),
    );

    expect(first.value, isNot(second.value));
  });

  test('different confidence produces a different identity', () {
    final first = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(
          confidence: EvidenceConfidence.verified,
        ),
      ),
    );

    final second = EvidenceIdentity.from(
      CanonicalEvidence.from(
        buildEvidence(
          confidence: EvidenceConfidence.inferred,
        ),
      ),
    );

    expect(first.value, isNot(second.value));
  });
}
