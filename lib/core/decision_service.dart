class ExecutiveDecision {
  const ExecutiveDecision({
    required this.id,
    required this.title,
    required this.status,
    required this.summary,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String status;
  final String summary;
  final DateTime createdAt;
}

class DecisionService {
  final List<ExecutiveDecision> _decisions = [];

  List<ExecutiveDecision> get decisions =>
      List.unmodifiable(_decisions);

  void add(ExecutiveDecision decision) {
    _decisions.add(decision);
  }

  ExecutiveDecision? byId(String id) {
    for (final decision in _decisions) {
      if (decision.id == id) {
        return decision;
      }
    }
    return null;
  }

  int get count => _decisions.length;

  void clear() {
    _decisions.clear();
  }
}
