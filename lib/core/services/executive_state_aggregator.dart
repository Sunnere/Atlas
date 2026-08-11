import '../contracts/branch_state.dart';
import '../contracts/executive_state.dart';

class ExecutiveStateAggregator {
  const ExecutiveStateAggregator();

  ExecutiveState aggregate(
    List<BranchState> branches, {
    List<String> priorities = const [],
  }) {
    return ExecutiveState(
      branches: List.unmodifiable(branches),
      priorities: List.unmodifiable(priorities),
    );
  }
}
