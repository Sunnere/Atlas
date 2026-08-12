import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';
import 'package:atlas/core/services/executive_decision_engine.dart';

void main() {
  group('Executive decision flow', () {
    test('runs the complete Matrix flow from branches to decision', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          inProgress: ['Improve Bonusvarsel conversion'],
          next: ['Expand BonusShop'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          blocked: ['Resolve historical data issue'],
          next: ['Run economic analysis'],
        ),
        BranchState(
          branch: 'Minihus Thailand',
          next: ['Evaluate lease candidates'],
        ),
      ];

      const engine = ExecutiveDecisionEngine();

      final decision = engine.decide(branches);

      expect(decision.priorities, hasLength(3));

      expect(
        decision.priorities.map((priority) => priority.branch),
        [
          'Growth OS',
          'Atlas Invest',
          'Minihus Thailand',
        ],
      );

      expect(
        decision.selectedPriority?.branch,
        'Atlas Invest',
      );

      expect(
        decision.selectedPriority?.action,
        'Resolve historical data issue',
      );

      expect(
        decision.selectedPriority?.rank,
        1,
      );

      expect(
        decision.rationale,
        'Atlas Invest has the highest-ranked actionable priority.',
      );
    });

    test('produces no decision when all branches are complete', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          completed: ['Bonusvarsel release'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          completed: ['Historical backtest'],
        ),
        BranchState(
          branch: 'Minihus Thailand',
          completed: ['Market research'],
        ),
      ];

      const engine = ExecutiveDecisionEngine();

      final decision = engine.decide(branches);

      expect(decision.priorities, isEmpty);
      expect(decision.selectedPriority, isNull);
      expect(
        decision.rationale,
        'No actionable priorities are available.',
      );
    });
  });
}
