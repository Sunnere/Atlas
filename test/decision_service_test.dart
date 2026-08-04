import 'package:atlas/core/decision_service.dart';
import 'package:test/test.dart';

void main() {
  group('DecisionService', () {
    test('starts empty', () {
      final service = DecisionService();

      expect(service.count, equals(0));
      expect(service.decisions, isEmpty);
    });

    test('adds a decision', () {
      final service = DecisionService();

      final decision = ExecutiveDecision(
        id: '0001',
        title: 'First Decision',
        status: 'Active',
        summary: 'Testing DecisionService',
        createdAt: DateTime(2026, 1, 1),
      );

      service.add(decision);

      expect(service.count, equals(1));
      expect(service.byId('0001'), isNotNull);
      expect(service.byId('0001')!.title, equals('First Decision'));
    });

    test('clear removes all decisions', () {
      final service = DecisionService();

      service.add(
        ExecutiveDecision(
          id: '0001',
          title: 'Decision',
          status: 'Active',
          summary: 'Summary',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      service.clear();

      expect(service.count, equals(0));
      expect(service.decisions, isEmpty);
    });
  });
}
