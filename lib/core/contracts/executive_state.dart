import 'branch_state.dart';

class ExecutiveState {
  const ExecutiveState({
    this.branches = const [],
    this.priorities = const [],
  });

  final List<BranchState> branches;
  final List<String> priorities;
}
