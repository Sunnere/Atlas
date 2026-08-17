import 'package:atlas/core/evidence/evidence.dart';
import 'package:atlas/core/evidence/evidence_confidence.dart';
import 'package:atlas/core/evidence/evidence_ledger.dart';
import 'package:atlas/core/evidence/evidence_type.dart';
import 'package:test/test.dart';

Evidence buildEvidence({
  required String id,
  String observation = 'Observed repository structure.',
}) {
  return Evidence(
    id: id,
    snapshotId: 'snapshot-001',
    source: 'repository',
    location: 'lib/example.dart',
    observation: observation,
    type: EvidenceType.structural,
    confidence: EvidenceConfidence.verified,
  );
}

void main() {
  test('starts empty', () {
    final ledger = EvidenceLedger();

    expect(ledger.length, 0);
    expect(ledger.all, isEmpty);
  });

  test('adds evidence', () {
    final ledger = EvidenceLedger();
    final evidence = buildEvidence(id: 'evidence-001');

    ledger.add(evidence);

    expect(ledger.length, 1);
    expect(ledger.contains('evidence-001'), isTrue);
    expect(ledger.getById('evidence-001'), same(evidence));
  });

  test('returns null for unknown evidence id', () {
    final ledger = EvidenceLedger();

    expect(ledger.getById('missing'), isNull);
    expect(ledger.contains('missing'), isFalse);
  });

  test('rejects duplicate evidence ids', () {
    final ledger = EvidenceLedger();

    ledger.add(
      buildEvidence(id: 'evidence-001'),
    );

    expect(
      () => ledger.add(
        buildEvidence(
          id: 'evidence-001',
          observation: 'Different observation.',
        ),
      ),
      throwsStateError,
    );

    expect(ledger.length, 1);
  });

  test('preserves insertion order', () {
    final ledger = EvidenceLedger();

    final first = buildEvidence(id: 'evidence-001');
    final second = buildEvidence(id: 'evidence-002');
    final third = buildEvidence(id: 'evidence-003');

    ledger.add(first);
    ledger.add(second);
    ledger.add(third);

    expect(
      ledger.all.toList(),
      [first, second, third],
    );
  });

  test('external collection cannot mutate the ledger', () {
    final ledger = EvidenceLedger();

    final evidence = buildEvidence(id: 'evidence-001');

    ledger.add(evidence);

    final exposed = ledger.all;

    expect(
      () => (exposed as List<Evidence>).add(
        buildEvidence(id: 'evidence-002'),
      ),
      throwsUnsupportedError,
    );

    expect(ledger.length, 1);
    expect(ledger.contains('evidence-002'), isFalse);
  });

  test('same evidence content may exist under different record ids', () {
    final ledger = EvidenceLedger();

    final first = buildEvidence(id: 'evidence-001');
    final second = buildEvidence(id: 'evidence-002');

    ledger.add(first);
    ledger.add(second);

    expect(ledger.length, 2);
    expect(ledger.getById('evidence-001'), same(first));
    expect(ledger.getById('evidence-002'), same(second));
  });

  test('ledger keeps evidence objects immutable', () {
    final ledger = EvidenceLedger();

    final evidence = buildEvidence(id: 'evidence-001');

    ledger.add(evidence);

    final stored = ledger.getById('evidence-001');

    expect(stored, same(evidence));
    expect(stored!.id, 'evidence-001');
    expect(stored.snapshotId, 'snapshot-001');
  });
}
