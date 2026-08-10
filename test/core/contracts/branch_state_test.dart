import 'package:test/test.dart';

import 'package:atlas/core/contracts/branch_state.dart';

void main() {
  group('BranchState', () {
    test('creates a branch status with the expected state', () {
      const state = BranchState(
        branch: 'Atlas Invest',
        completed: [
          'Signal contract',
          'Market observation',
        ],
        inProgress: [
          'Historical intelligence',
        ],
        blocked: [],
        next: [
          'Regime detection',
        ],
        dependencies: [
          'Historical market data',
        ],
        sharedCapabilities: [
          'Signal contract',
        ],
      );

      expect(state.branch, 'Atlas Invest');
      expect(state.completed, hasLength(2));
      expect(state.inProgress, hasLength(1));
      expect(state.blocked, isEmpty);
      expect(state.next, contains('Regime detection'));
      expect(
        state.dependencies,
        contains('Historical market data'),
      );
      expect(
        state.sharedCapabilities,
        contains('Signal contract'),
      );
    });

    test('supports an empty branch state', () {
      const state = BranchState(
        branch: 'Growth OS',
      );

      expect(state.completed, isEmpty);
      expect(state.inProgress, isEmpty);
      expect(state.blocked, isEmpty);
      expect(state.next, isEmpty);
      expect(state.dependencies, isEmpty);
      expect(state.sharedCapabilities, isEmpty);
    });
  });
}
