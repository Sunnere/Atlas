class ExecutiveDecision {
  const ExecutiveDecision({
    required this.id,
    required this.title,
    required this.status,
    required this.context,
    required this.decision,
    required this.reasoning,
    required this.impact,
    required this.createdAt,
    this.tags = const [],
    this.projects = const [],
  });

  final String id;
  final String title;
  final String status;

  final String context;
  final String decision;
  final String reasoning;
  final String impact;

  final DateTime createdAt;

  final List<String> tags;
  final List<String> projects;
}
