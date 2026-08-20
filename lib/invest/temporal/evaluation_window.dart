class EvaluationWindow {
  final int signalIndex;
  final int horizon;
  final int endIndex;
  final DateTime signalTimestamp;
  final DateTime endTimestamp;

  const EvaluationWindow({
    required this.signalIndex,
    required this.horizon,
    required this.endIndex,
    required this.signalTimestamp,
    required this.endTimestamp,
  });

  static EvaluationWindow create({
    required List<DateTime> timestamps,
    required int signalIndex,
    required int horizon,
    DateTime? boundaryStart,
    DateTime? boundaryEnd,
  }) {
    if (timestamps.isEmpty) {
      throw ArgumentError('Evaluation requires at least one timestamp.');
    }

    if (horizon <= 0) {
      throw ArgumentError('Evaluation horizon must be greater than zero.');
    }

    if (signalIndex < 0 || signalIndex >= timestamps.length) {
      throw RangeError.index(
        signalIndex,
        timestamps,
        'signalIndex',
      );
    }

    for (var i = 1; i < timestamps.length; i++) {
      if (timestamps[i].isBefore(timestamps[i - 1])) {
        throw ArgumentError(
          'Evaluation timestamps must be in chronological order.',
        );
      }
    }

    final endIndex = signalIndex + horizon;

    if (endIndex >= timestamps.length) {
      throw StateError(
        'Evaluation horizon extends beyond available observations.',
      );
    }

    final signalTimestamp = timestamps[signalIndex];
    final endTimestamp = timestamps[endIndex];

    if (boundaryStart != null &&
        signalTimestamp.isBefore(boundaryStart)) {
      throw StateError(
        'Signal timestamp is before the evaluation boundary.',
      );
    }

    if (boundaryEnd != null &&
        !signalTimestamp.isBefore(boundaryEnd)) {
      throw StateError(
        'Signal timestamp is outside the evaluation boundary.',
      );
    }

    if (boundaryEnd != null &&
        !endTimestamp.isBefore(boundaryEnd)) {
      throw StateError(
        'Evaluation horizon crosses the evaluation boundary.',
      );
    }

    if (boundaryStart != null &&
        endTimestamp.isBefore(boundaryStart)) {
      throw StateError(
        'Evaluation outcome is before the evaluation boundary.',
      );
    }

    return EvaluationWindow(
      signalIndex: signalIndex,
      horizon: horizon,
      endIndex: endIndex,
      signalTimestamp: signalTimestamp,
      endTimestamp: endTimestamp,
    );
  }

  Iterable<int> get outcomeIndices sync* {
    for (var index = signalIndex + 1;
        index <= endIndex;
        index++) {
      yield index;
    }
  }
}
