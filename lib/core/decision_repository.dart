import 'package:atlas/core/executive_decision.dart';

class DecisionRepository {
  final List<ExecutiveDecision> _decisions = [];

  List<ExecutiveDecision> get all =>
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

  void clear() {
    _decisions.clear();
  }

  int get count => _decisions.length;
}
