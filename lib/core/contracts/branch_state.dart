class BranchState {
  const BranchState({
    required this.branch,
    this.completed = const [],
    this.inProgress = const [],
    this.blocked = const [],
    this.next = const [],
    this.dependencies = const [],
    this.sharedCapabilities = const [],
  });

  final String branch;
  final List<String> completed;
  final List<String> inProgress;
  final List<String> blocked;
  final List<String> next;
  final List<String> dependencies;
  final List<String> sharedCapabilities;
}
