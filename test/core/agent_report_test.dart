import 'package:atlas/core/contracts/agent_report.dart';
import 'package:atlas/core/evidence/evidence.dart';
import 'package:atlas/core/evidence/evidence_confidence.dart';
import 'package:atlas/core/evidence/evidence_ledger.dart';
import 'package:atlas/core/evidence/evidence_type.dart';
import 'package:test/test.dart';

Evidence buildEvidence({
  required String id,
  String observation = 'Observed repository structure.',
  EvidenceConfidence confidence = EvidenceConfidence.verified,
}) {
  return Evidence(
    id: id,
    snapshotId: 'snapshot-001',
    source: 'repository',
    location: 'lib/example.dart',
    observation: observation,
    type: EvidenceType.structural,
    confidence: confidence,
  );
}

void main() {
  group('AgentReport', () {
    test('stores a complete traceable agent assessment', () {
      final capturedAt = DateTime.utc(2026, 8, 17, 8);

      final evidence = [
        buildEvidence(
          id: 'evidence-company-registration',
          observation: 'Company is registered.',
        ),
        buildEvidence(
          id: 'evidence-contract-authority',
          observation:
              'Representative claims signing authority.',
          confidence: EvidenceConfidence.requiresReview,
        ),
      ];

      final report = AgentReport(
        agent: 'Counterparty Verification',
        capturedAt: capturedAt,
        observations: [
          'Company registration was found.',
          'Representative identity requires confirmation.',
        ],
        evidence: evidence,
        assessment:
            'The counterparty appears legitimate, but authority is not fully verified.',
        confidence: 0.82,
        risks: [
          'Signing authority has not been independently confirmed.',
        ],
        conflicts: const [],
        recommendation:
            'Proceed only after authority verification.',
        validationRequests: [
          'Verify representative signing authority.',
        ],
      );

      expect(report.agent, 'Counterparty Verification');
      expect(report.capturedAt, capturedAt);
      expect(report.observations, hasLength(2));
      expect(report.evidence, hasLength(2));
      expect(report.assessment, contains('not fully verified'));
      expect(report.confidence, 0.82);
      expect(report.risks, hasLength(1));
      expect(report.conflicts, isEmpty);
      expect(
        report.recommendation,
        contains('authority verification'),
      );
      expect(report.validationRequests, hasLength(1));

      expect(report.hasUnverifiedEvidence, isTrue);
      expect(report.requiresValidation, isTrue);
      expect(report.hasConflicts, isFalse);
      expect(report.hasEvidenceReferences, isTrue);

      expect(
        report.evidenceIds,
        [
          'evidence-company-registration',
          'evidence-contract-authority',
        ],
      );
    });

    test('detects unresolved canonical evidence', () {
      final ledger = EvidenceLedger();

      ledger.add(
        buildEvidence(id: 'evidence-existing'),
      );

      final report = AgentReport(
        agent: 'Evidence Agent',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: const ['Evidence checked.'],
        evidence: [
          buildEvidence(id: 'evidence-existing'),
          buildEvidence(
            id: 'evidence-missing',
            observation: 'Representative has authority.',
          ),
        ],
        assessment:
            'One evidence record is missing from the ledger.',
        confidence: 0.7,
        risks: const ['Missing evidence record.'],
        conflicts: const [],
        recommendation:
            'Request missing evidence.',
        validationRequests: const [
          'Resolve missing evidence.',
        ],
      );

      expect(
        report.unresolvedEvidenceIds(ledger),
        ['evidence-missing'],
      );

      expect(
        report.hasResolvedEvidence(ledger),
        isFalse,
      );
    });

    test('confirms all canonical evidence is resolved', () {
      final ledger = EvidenceLedger();

      final first = buildEvidence(
        id: 'evidence-001',
      );

      final second = buildEvidence(
        id: 'evidence-002',
        observation: 'Second verified observation.',
      );

      ledger.add(first);
      ledger.add(second);

      final report = AgentReport(
        agent: 'Verification Agent',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: const [
          'Two evidence records were reviewed.',
        ],
        evidence: [
          first,
          second,
        ],
        assessment:
            'Both evidence records resolve.',
        confidence: 1.0,
        risks: const [],
        conflicts: const [],
        recommendation: 'Proceed.',
        validationRequests: const [],
      );

      expect(
        report.unresolvedEvidenceIds(ledger),
        isEmpty,
      );

      expect(
        report.hasResolvedEvidence(ledger),
        isTrue,
      );
    });

    test('creates an immutable report boundary', () {
      final observations = ['Initial observation'];

      final evidence = [
        buildEvidence(id: 'evidence-001'),
      ];

      final report = AgentReport(
        agent: 'Research',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: observations,
        evidence: evidence,
        assessment: 'Assessment',
        confidence: 1.0,
        risks: const [],
        conflicts: const [],
        recommendation: 'Proceed',
        validationRequests: const [],
      );

      observations.add('Mutation after construction');
      evidence.add(
        buildEvidence(
          id: 'evidence-002',
          observation: 'Mutation after construction.',
        ),
      );

      expect(report.observations, hasLength(1));
      expect(report.evidence, hasLength(1));
    });

    test('detects unverified evidence', () {
      final report = AgentReport(
        agent: 'Legal Verification',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: const [
          'Contract requires review.',
        ],
        evidence: [
          buildEvidence(
            id: 'evidence-review',
            observation:
                'Authority clause requires review.',
            confidence:
                EvidenceConfidence.requiresReview,
          ),
        ],
        assessment:
            'Further verification is required.',
        confidence: 0.6,
        risks: const [
          'Unverified authority.',
        ],
        conflicts: const [],
        recommendation:
            'Do not proceed yet.',
        validationRequests: const [
          'Obtain independent legal verification.',
        ],
      );

      expect(
        report.hasUnverifiedEvidence,
        isTrue,
      );
      expect(
        report.requiresValidation,
        isTrue,
      );
    });

    test('accepts fully verified evidence', () {
      final report = AgentReport(
        agent: 'Research',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: const [
          'Verified observation.',
        ],
        evidence: [
          buildEvidence(
            id: 'evidence-verified',
          ),
        ],
        assessment: 'Evidence is verified.',
        confidence: 0.95,
        risks: const [],
        conflicts: const [],
        recommendation: 'Proceed.',
        validationRequests: const [],
      );

      expect(
        report.hasUnverifiedEvidence,
        isFalse,
      );
      expect(
        report.requiresValidation,
        isFalse,
      );
      expect(
        report.hasConflicts,
        isFalse,
      );
    });

    test('detects conflicts', () {
      final report = AgentReport(
        agent: 'Red Team',
        capturedAt: DateTime.utc(2026, 8, 17),
        observations: const [
          'Counter-evidence found.',
        ],
        evidence: const [],
        assessment:
            'The original hypothesis may be incorrect.',
        confidence: 0.7,
        risks: const [
          'Confirmation bias.',
        ],
        conflicts: const [
          'Conflicts with Growth Agent assessment.',
        ],
        recommendation:
            'Investigate before proceeding.',
        validationRequests: const [
          'Independent verification required.',
        ],
      );

      expect(report.hasConflicts, isTrue);
      expect(report.requiresValidation, isTrue);
    });

    test('rejects confidence outside the valid range', () {
      expect(
        () => AgentReport(
          agent: 'Test',
          capturedAt: DateTime.utc(2026, 8, 17),
          observations: const [],
          evidence: const [],
          assessment: 'Assessment',
          confidence: 1.1,
          risks: const [],
          conflicts: const [],
          recommendation: 'None',
          validationRequests: const [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
