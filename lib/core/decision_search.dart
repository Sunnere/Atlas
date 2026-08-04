import 'package:atlas/core/executive_decision.dart';

class DecisionSearch {
  const DecisionSearch();

  List<ExecutiveDecision> search({
    required Iterable<ExecutiveDecision> decisions,
    required String query,
  }) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      return decisions.toList(growable: false);
    }

    return decisions.where((decision) {
      return decision.id.toLowerCase().contains(q) ||
          decision.title.toLowerCase().contains(q) ||
          decision.context.toLowerCase().contains(q) ||
          decision.decision.toLowerCase().contains(q) ||
          decision.reasoning.toLowerCase().contains(q) ||
          decision.impact.toLowerCase().contains(q) ||
          decision.tags.any((tag) => tag.toLowerCase().contains(q)) ||
          decision.projects.any(
            (project) => project.toLowerCase().contains(q),
          );
    }).toList(growable: false);
  }
}
