import 'package:test/test.dart';

import 'package:atlas/core/contracts/executive_decision.dart';
import 'package:atlas/core/contracts/executive_priority.dart';

void main() {
  group('ExecutiveDecision', () {
    test('stores priorities, selected priority and rationale', () {
      const priority = ExecutivePriority(
        branch: 'Growth OS',
        action: 'Improve conversion',
        rationale: 'Conversion is the current growth bottleneck.',
        rank: 1,
      );

      const decision = ExecutiveDecision(
        priorities: [priority],
        selectedPriority: priority,
        rationale: 'Growth OS has the highest-ranked actionable priority.',
      );

      expect(decision.priorities, hasLength(1));
      expect(decision.selectedPriority, priority);
      expect(decision.selectedPriority?.branch, 'Growth OS');
      expect(decision.selectedPriority?.action, 'Improve conversion');
      expect(
        decision.rationale,
        'Growth OS has the highest-ranked actionable priority.',
      );
    });

    test('supports a decision without a selected priority', () {
      const decision = ExecutiveDecision(
        priorities: [],
        rationale: 'No actionable priorities are available.',
      );

      expect(decision.priorities, isEmpty);
      expect(decision.selectedPriority, isNull);
      expect(
        decision.rationale,
        'No actionable priorities are available.',
      );
    });
  });
}
