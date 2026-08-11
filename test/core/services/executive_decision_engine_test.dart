import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';
import 'package:atlas/core/services/executive_decision_engine.dart';

void main() {
  group('ExecutiveDecisionEngine', () {
    const engine = ExecutiveDecisionEngine();

    test('selects the highest-ranked actionable priority', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          next: ['Improve conversion'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          blocked: ['Resolve data issue'],
        ),
        BranchState(
          branch: 'Minihus Thailand',
          inProgress: ['Evaluate candidates'],
        ),
      ];

      final decision = engine.decide(branches);

      expect(decision.priorities, hasLength(3));
      expect(decision.selectedPriority, isNotNull);
      expect(decision.selectedPriority?.branch, 'Atlas Invest');
      expect(decision.selectedPriority?.action, 'Resolve data issue');
      expect(decision.selectedPriority?.rank, 1);
      expect(
        decision.rationale,
        'Atlas Invest has the highest-ranked actionable priority.',
      );
    });

    test('returns all priorities in deterministic branch order', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          blocked: ['Payment issue'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          blocked: ['Data issue'],
        ),
        BranchState(
          branch: 'Minihus Thailand',
          next: ['Lease research'],
        ),
      ];

      final decision = engine.decide(branches);

      expect(
        decision.priorities.map((priority) => priority.branch),
        ['Growth OS', 'Atlas Invest', 'Minihus Thailand'],
      );
    });

    test('returns no selected priority when no actionable work exists', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          completed: ['Bonusvarsel'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          completed: ['Historical analysis'],
        ),
      ];

      final decision = engine.decide(branches);

      expect(decision.priorities, isEmpty);
      expect(decision.selectedPriority, isNull);
      expect(
        decision.rationale,
        'No actionable priorities are available.',
      );
    });

    test('preserves the prioritization service as the source of ranking', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          inProgress: ['Continue Bonusvarsel'],
        ),
        BranchState(
          branch: 'Minihus Thailand',
          next: ['Research lease'],
        ),
      ];

      final decision = engine.decide(branches);

      expect(decision.selectedPriority?.branch, 'Growth OS');
      expect(decision.selectedPriority?.rank, 2);
    });
  });
}
