class BacktestResult {
  final int totalSignals;
  final int correctSignals;
  final int incorrectSignals;
  final int waitSignals;

  const BacktestResult({
    required this.totalSignals,
    required this.correctSignals,
    required this.incorrectSignals,
    required this.waitSignals,
  });

  double get hitRate {
    final evaluated = correctSignals + incorrectSignals;

    if (evaluated == 0) {
      return 0;
    }

    return correctSignals / evaluated;
  }
}
