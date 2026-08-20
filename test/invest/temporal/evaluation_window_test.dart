import 'package:test/test.dart';

import '../../../lib/invest/temporal/evaluation_window.dart';

List<DateTime> timestamps(int count) {
  return List.generate(
    count,
    (index) => DateTime.utc(
      2026,
      1,
      index + 1,
    ),
  );
}

void main() {
  group('EvaluationWindow', () {
    test('creates a valid forward evaluation window', () {
      final result = EvaluationWindow.create(
        timestamps: timestamps(10),
        signalIndex: 2,
        horizon: 3,
      );

      expect(result.signalIndex, 2);
      expect(result.horizon, 3);
      expect(result.endIndex, 5);

      expect(
        result.outcomeIndices,
        [3, 4, 5],
      );
    });

    test('starts outcome at t+1', () {
      final result = EvaluationWindow.create(
        timestamps: timestamps(5),
        signalIndex: 1,
        horizon: 2,
      );

      expect(
        result.outcomeIndices.first,
        2,
      );

      expect(
        result.outcomeIndices,
        isNot(contains(1)),
      );
    });

    test('allows a horizon ending exactly before boundary end',
        () {
      final result = EvaluationWindow.create(
        timestamps: timestamps(10),
        signalIndex: 2,
        horizon: 3,
        boundaryStart: DateTime.utc(2026, 1, 1),
        boundaryEnd: DateTime.utc(2026, 1, 7),
      );

      expect(result.endIndex, 5);
      expect(
        result.endTimestamp,
        DateTime.utc(2026, 1, 6),
      );
    });

    test('rejects a horizon crossing the evaluation boundary', () {
      expect(
        () => EvaluationWindow.create(
          timestamps: timestamps(10),
          signalIndex: 3,
          horizon: 3,
          boundaryStart: DateTime.utc(2026, 1, 1),
          boundaryEnd: DateTime.utc(2026, 1, 6),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects a signal outside the evaluation boundary', () {
      expect(
        () => EvaluationWindow.create(
          timestamps: timestamps(10),
          signalIndex: 5,
          horizon: 1,
          boundaryStart: DateTime.utc(2026, 1, 1),
          boundaryEnd: DateTime.utc(2026, 1, 6),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects insufficient future observations', () {
      expect(
        () => EvaluationWindow.create(
          timestamps: timestamps(5),
          signalIndex: 3,
          horizon: 2,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects non-positive horizons', () {
      expect(
        () => EvaluationWindow.create(
          timestamps: timestamps(5),
          signalIndex: 1,
          horizon: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects negative signal indexes', () {
      expect(
        () => EvaluationWindow.create(
          timestamps: timestamps(5),
          signalIndex: -1,
          horizon: 1,
        ),
        throwsA(isA<RangeError>()),
      );
    });

    test('rejects non-chronological timestamps', () {
      final values = [
        DateTime.utc(2026, 1, 1),
        DateTime.utc(2026, 1, 3),
        DateTime.utc(2026, 1, 2),
        DateTime.utc(2026, 1, 4),
      ];

      expect(
        () => EvaluationWindow.create(
          timestamps: values,
          signalIndex: 1,
          horizon: 1,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('keeps signal and outcome inside the same boundary', () {
      final result = EvaluationWindow.create(
        timestamps: timestamps(10),
        signalIndex: 1,
        horizon: 2,
        boundaryStart: DateTime.utc(2026, 1, 1),
        boundaryEnd: DateTime.utc(2026, 1, 5),
      );

      expect(
        result.signalTimestamp,
        DateTime.utc(2026, 1, 2),
      );

      expect(
        result.endTimestamp,
        DateTime.utc(2026, 1, 4),
      );
    });
  });
}
