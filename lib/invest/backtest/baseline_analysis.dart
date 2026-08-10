import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import 'atlas_backtest.dart';

class SignalAnalysis {
  final int count;
  final int correct;
  final int incorrect;
  final double averageForwardReturnPercent;

  const SignalAnalysis({
    required this.count,
    required this.correct,
    required this.incorrect,
    required this.averageForwardReturnPercent,
  });

  double get hitRate {
    if (count == 0) {
      return 0;
    }

    return correct / count;
  }
}

class BaselineAnalysis {
  final SignalAnalysis buy;
  final SignalAnalysis sell;
  final int waitSignals;

  const BaselineAnalysis({
    required this.buy,
    required this.sell,
    required this.waitSignals,
  });
}

class AtlasBaselineAnalyzer {
  final AtlasSignalEngine engine;

  const AtlasBaselineAnalyzer({
    this.engine = const AtlasSignalEngine(),
  });

  BaselineAnalysis analyze(List<BacktestCase> cases) {
    var buyCount = 0;
    var buyCorrect = 0;
    var buyIncorrect = 0;
    var buyReturn = 0.0;

    var sellCount = 0;
    var sellCorrect = 0;
    var sellIncorrect = 0;
    var sellReturn = 0.0;

    var waitCount = 0;

    for (final testCase in cases) {
      final signal = engine.evaluate(testCase.observation);

      switch (signal.direction) {
        case SignalDirection.buy:
          buyCount++;
          buyReturn += testCase.futurePriceChangePercent;

          if (testCase.futurePriceChangePercent > 0) {
            buyCorrect++;
          } else {
            buyIncorrect++;
          }

        case SignalDirection.sell:
          sellCount++;
          sellReturn += -testCase.futurePriceChangePercent;

          if (testCase.futurePriceChangePercent < 0) {
            sellCorrect++;
          } else {
            sellIncorrect++;
          }

        case SignalDirection.wait:
          waitCount++;
      }
    }

    return BaselineAnalysis(
      buy: SignalAnalysis(
        count: buyCount,
        correct: buyCorrect,
        incorrect: buyIncorrect,
        averageForwardReturnPercent:
            buyCount == 0 ? 0 : buyReturn / buyCount,
      ),
      sell: SignalAnalysis(
        count: sellCount,
        correct: sellCorrect,
        incorrect: sellIncorrect,
        averageForwardReturnPercent:
            sellCount == 0 ? 0 : sellReturn / sellCount,
      ),
      waitSignals: waitCount,
    );
  }
}
