import 'executive_priority.dart';

class ExecutiveDecision {
  const ExecutiveDecision({
    required this.priorities,
    this.selectedPriority,
    required this.rationale,
  });

  final List<ExecutivePriority> priorities;
  final ExecutivePriority? selectedPriority;
  final String rationale;
}
