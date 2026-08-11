class ExecutivePriority {
  const ExecutivePriority({
    required this.branch,
    required this.action,
    required this.rationale,
    this.rank = 0,
  });

  final String branch;
  final String action;
  final String rationale;
  final int rank;
}
