import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';
import 'package:atlas/core/services/executive_state_aggregator.dart';

void main() {
  group('ExecutiveStateAggregator', () {
    const aggregator = ExecutiveStateAggregator();

    test('aggregates multiple branch states', () {
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

      final state = aggregator.aggregate(
        [growth, invest],
        priorities: [
          'Complete Executive State',
          'Coordinate Matrix',
        ],
      );

      expect(state.branches, hasLength(2));
      expect(state.branches[0].branch, 'Growth OS');
      expect(state.branches[1].branch, 'Atlas Invest');
      expect(
        state.priorities,
        contains('Coordinate Matrix'),
      );
    });

    test('aggregates an empty branch list', () {
      final state = aggregator.aggregate([]);

      expect(state.branches, isEmpty);
      expect(state.priorities, isEmpty);
    });

    test('preserves branch state without changing it', () {
      const branch = BranchState(
        branch: 'Minihus Thailand',
        completed: ['Market research'],
        blocked: ['Supplier confirmation'],
      );

      final state = aggregator.aggregate([branch]);

      expect(
        state.branches.single.completed,
        contains('Market research'),
      );
      expect(
        state.branches.single.blocked,
        contains('Supplier confirmation'),
      );
    });
  });
}
