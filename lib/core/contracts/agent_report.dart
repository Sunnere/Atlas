import '../evidence/evidence.dart';
import '../evidence/evidence_confidence.dart';
import '../evidence/evidence_ledger.dart';

class AgentReport {
  AgentReport({
    required this.agent,
    required this.capturedAt,
    required List<String> observations,
    required List<Evidence> evidence,
    required this.assessment,
    required this.confidence,
    required List<String> risks,
    required List<String> conflicts,
    required this.recommendation,
    required List<String> validationRequests,
  })  : assert(confidence >= 0 && confidence <= 1),
        observations = List.unmodifiable(observations),
        evidence = List.unmodifiable(evidence),
        risks = List.unmodifiable(risks),
        conflicts = List.unmodifiable(conflicts),
        validationRequests = List.unmodifiable(validationRequests);

  final String agent;
  final DateTime capturedAt;

  /// Direct observations made by the agent.
  final List<String> observations;

  /// Canonical Evidence records supporting the assessment.
  final List<Evidence> evidence;

  /// The agent's interpretation of the available evidence.
  final String assessment;

  /// Confidence expressed as a value from 0.0 to 1.0.
  final double confidence;

  /// Known risks or factors that could invalidate the assessment.
  final List<String> risks;

  /// Conflicting evidence, opinions, or agent conclusions.
  final List<String> conflicts;

  /// The agent's recommended action.
  final String recommendation;

  /// Questions or checks that must be completed before a decision.
  final List<String> validationRequests;

  /// True when at least one evidence record is not fully verified.
  bool get hasUnverifiedEvidence => evidence.any(
        (item) => item.confidence != EvidenceConfidence.verified,
      );

  bool get requiresValidation => validationRequests.isNotEmpty;

  bool get hasConflicts => conflicts.isNotEmpty;

  /// True when the report contains canonical Evidence records.
  bool get hasEvidenceReferences => evidence.isNotEmpty;

  /// Returns the canonical Evidence IDs referenced by this report.
  List<String> get evidenceIds {
    return List.unmodifiable(
      evidence.map((item) => item.id),
    );
  }

  /// Returns Evidence IDs that cannot be resolved in the ledger.
  List<String> unresolvedEvidenceIds(EvidenceLedger ledger) {
    return List.unmodifiable(
      evidenceIds.where((id) => !ledger.contains(id)),
    );
  }

  /// True only when every Evidence record in the report
  /// exists in the supplied ledger.
  bool hasResolvedEvidence(EvidenceLedger ledger) {
    return unresolvedEvidenceIds(ledger).isEmpty;
  }
}
