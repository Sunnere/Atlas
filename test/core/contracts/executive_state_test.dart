import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';
import 'package:atlas/core/contracts/executive_state.dart';

void main() {
  group('ExecutiveState', () {
    test('aggregates branch states and priorities', () {
      const growth = BranchState(
        branch: 'Growth OS',
        inProgress: ['Bonusvarsel'],
        next: ['Improve conversion'],
      );

      const invest = BranchState(
        branch: 'Atlas Invest',
        completed: ['Historical backtesting'],
        next: ['Historical intelligence'],
      );

      const state = ExecutiveState(
        branches: [growth, invest],
        priorities: [
          'Complete Executive State',
          'Coordinate Matrix',
        ],
      );

      expect(state.branches, hasLength(2));
      expect(state.branches.first.branch, 'Growth OS');
      expect(state.branches.last.branch, 'Atlas Invest');
      expect(
        state.priorities,
        contains('Coordinate Matrix'),
      );
    });

    test('supports an empty executive state', () {
      const state = ExecutiveState();

      expect(state.branches, isEmpty);
      expect(state.priorities, isEmpty);
    });
  });
}
