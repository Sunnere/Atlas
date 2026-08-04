import 'package:atlas/core/decision_search.dart';
import 'package:atlas/core/executive_decision.dart';
import 'package:test/test.dart';

void main() {
  group('DecisionSearch', () {
    const search = DecisionSearch();

    final decisions = [
      ExecutiveDecision(
        id: '0062',
        title: 'Separate Atlas Repository',
        status: 'Accepted',
        context: 'Atlas was inside Bonusvarsel.',
        decision: 'Move Atlas to its own repository.',
        reasoning: 'Independent lifecycle.',
        impact: 'Cleaner architecture.',
        createdAt: DateTime(2026, 8, 4),
        tags: ['architecture'],
        projects: ['Atlas'],
      ),
      ExecutiveDecision(
        id: '0063',
        title: 'Executive Memory',
        status: 'Accepted',
        context: 'Sprint 11',
        decision: 'Introduce Executive Memory.',
        reasoning: 'Institutional knowledge.',
        impact: 'Searchable decisions.',
        createdAt: DateTime(2026, 8, 4),
        tags: ['memory'],
        projects: ['Atlas'],
      ),
    ];

    test('finds by title', () {
      final result = search.search(
        decisions: decisions,
        query: 'repository',
      );

      expect(result.length, 1);
      expect(result.first.id, '0062');
    });

    test('finds by tag', () {
      final result = search.search(
        decisions: decisions,
        query: 'memory',
      );

      expect(result.length, 1);
      expect(result.first.id, '0063');
    });

    test('returns all for empty query', () {
      final result = search.search(
        decisions: decisions,
        query: '',
      );

      expect(result.length, 2);
    });
  });
}
