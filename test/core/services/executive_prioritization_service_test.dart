import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';
import 'package:atlas/core/services/executive_prioritization_service.dart';

void main() {
  group('ExecutivePrioritizationService', () {
    const service = ExecutivePrioritizationService();

    test('prioritizes blocked work first', () {
      const branch = BranchState(
        branch: 'Growth OS',
        inProgress: ['Continue product work'],
        blocked: ['Resolve payment issue'],
        next: ['Improve conversion'],
      );

      final priorities = service.prioritize([branch]);

      expect(priorities, hasLength(1));
      expect(priorities.single.branch, 'Growth OS');
      expect(priorities.single.action, 'Resolve payment issue');
      expect(priorities.single.rank, 1);
      expect(
        priorities.single.rationale,
        'Branch has a blocked item requiring attention.',
      );
    });

    test('uses in-progress work when branch is not blocked', () {
      const branch = BranchState(
        branch: 'Growth OS',
        inProgress: ['Continue product work'],
        next: ['Improve conversion'],
      );

      final priorities = service.prioritize([branch]);

      expect(priorities, hasLength(1));
      expect(priorities.single.action, 'Continue product work');
      expect(priorities.single.rank, 2);
    });

    test('uses next action when branch has no blocked or in-progress work', () {
      const branch = BranchState(
        branch: 'Minihus Thailand',
        next: ['Evaluate lease candidates'],
      );

      final priorities = service.prioritize([branch]);

      expect(priorities, hasLength(1));
      expect(priorities.single.action, 'Evaluate lease candidates');
      expect(priorities.single.rank, 3);
    });

    test('ignores branches without actionable work', () {
      const branch = BranchState(
        branch: 'Atlas Invest',
        completed: ['Historical backtesting'],
      );

      final priorities = service.prioritize([branch]);

      expect(priorities, isEmpty);
    });

    test('preserves branch identity', () {
      const branches = [
        BranchState(
          branch: 'Growth OS',
          inProgress: ['Bonusvarsel'],
        ),
        BranchState(
          branch: 'Atlas Invest',
          next: ['Run analysis'],
        ),
      ];

      final priorities = service.prioritize(branches);

      expect(priorities, hasLength(2));
      expect(priorities[0].branch, 'Growth OS');
      expect(priorities[1].branch, 'Atlas Invest');
    });

    test('uses deterministic branch order', () {
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

      final priorities = service.prioritize(branches);

      expect(
        priorities.map((priority) => priority.branch),
        ['Growth OS', 'Atlas Invest', 'Minihus Thailand'],
      );
    });
  });
}
