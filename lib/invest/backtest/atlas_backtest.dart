import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import 'backtest_result.dart';

class BacktestCase {
  final MarketObservation observation;
  final double futurePriceChangePercent;

  const BacktestCase({
    required this.observation,
    required this.futurePriceChangePercent,
  });
}

class AtlasBacktest {
  final AtlasSignalEngine engine;

  const AtlasBacktest({
    this.engine = const AtlasSignalEngine(),
  });

  BacktestResult run(List<BacktestCase> cases) {
    var correct = 0;
    var incorrect = 0;
    var wait = 0;

    for (final testCase in cases) {
      final signal = engine.evaluate(testCase.observation);

      switch (signal.direction) {
        case SignalDirection.buy:
          if (testCase.futurePriceChangePercent > 0) {
            correct++;
          } else {
            incorrect++;
          }

        case SignalDirection.sell:
          if (testCase.futurePriceChangePercent < 0) {
            correct++;
          } else {
            incorrect++;
          }

        case SignalDirection.wait:
          wait++;
      }
    }

    return BacktestResult(
      totalSignals: correct + incorrect,
      correctSignals: correct,
      incorrectSignals: incorrect,
      waitSignals: wait,
    );
  }
}
