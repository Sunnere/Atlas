import '../contracts/branch_state.dart';
import '../contracts/executive_priority.dart';

class ExecutivePrioritizationService {
  const ExecutivePrioritizationService();

  List<ExecutivePriority> prioritize(
    List<BranchState> branches,
  ) {
    final priorities = <ExecutivePriority>[];

    for (final branch in branches) {
      if (branch.blocked.isNotEmpty) {
        priorities.add(
          ExecutivePriority(
            branch: branch.branch,
            action: branch.blocked.first,
            rationale: 'Branch has a blocked item requiring attention.',
            rank: 1,
          ),
        );
        continue;
      }

      if (branch.inProgress.isNotEmpty) {
        priorities.add(
          ExecutivePriority(
            branch: branch.branch,
            action: branch.inProgress.first,
            rationale: 'Branch has work in progress.',
            rank: 2,
          ),
        );
        continue;
      }

      if (branch.next.isNotEmpty) {
        priorities.add(
          ExecutivePriority(
            branch: branch.branch,
            action: branch.next.first,
            rationale: 'Branch has a defined next action.',
            rank: 3,
          ),
        );
      }
    }

    return List.unmodifiable(priorities);
  }
}
