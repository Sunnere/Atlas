import 'package:test/test.dart';

import 'package:atlas/core/contracts/executive_priority.dart';

void main() {
  group('ExecutivePriority', () {
    test('stores executive priority information', () {
      const priority = ExecutivePriority(
        branch: 'Growth OS',
        action: 'Improve Bonusvarsel conversion',
        rationale: 'Conversion is the current growth bottleneck.',
        rank: 1,
      );

      expect(priority.branch, 'Growth OS');
      expect(
        priority.action,
        'Improve Bonusvarsel conversion',
      );
      expect(
        priority.rationale,
        'Conversion is the current growth bottleneck.',
      );
      expect(priority.rank, 1);
    });

    test('defaults rank to zero', () {
      const priority = ExecutivePriority(
        branch: 'Atlas Invest',
        action: 'Run historical analysis',
        rationale: 'Historical evidence is required.',
      );

      expect(priority.rank, 0);
    });
  });
}
