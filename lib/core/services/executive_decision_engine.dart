import '../contracts/branch_state.dart';
import '../contracts/executive_decision.dart';
import 'executive_prioritization_service.dart';

class ExecutiveDecisionEngine {
  const ExecutiveDecisionEngine({
    this.prioritizationService = const ExecutivePrioritizationService(),
  });

  final ExecutivePrioritizationService prioritizationService;

  ExecutiveDecision decide(
    List<BranchState> branches,
  ) {
    final priorities = prioritizationService.prioritize(branches);

    if (priorities.isEmpty) {
      return const ExecutiveDecision(
        priorities: [],
        rationale: 'No actionable priorities are available.',
      );
    }

    final selectedPriority = priorities.reduce(
      (current, candidate) {
        if (candidate.rank < current.rank) {
          return candidate;
        }

        return current;
      },
    );

    return ExecutiveDecision(
      priorities: priorities,
      selectedPriority: selectedPriority,
      rationale:
          '${selectedPriority.branch} has the highest-ranked actionable priority.',
    );
  }
}
