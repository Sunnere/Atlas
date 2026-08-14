import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import 'forward_return_calculator.dart';

class ForwardHorizonResult {
  final int horizonDays;
  final int buySignals;
  final int sellSignals;
  final double buyAverageReturnPercent;
  final double sellAverageReturnPercent;
  final double buyHitRate;
  final double sellHitRate;

  const ForwardHorizonResult({
    required this.horizonDays,
    required this.buySignals,
    required this.sellSignals,
    required this.buyAverageReturnPercent,
    required this.sellAverageReturnPercent,
    required this.buyHitRate,
    required this.sellHitRate,
  });
}

class AtlasForwardHorizonAnalyzer {
  final AtlasSignalEngine engine;
  final ForwardReturnCalculator returnCalculator;

  const AtlasForwardHorizonAnalyzer({
    this.engine = const AtlasSignalEngine(),
    this.returnCalculator = const ForwardReturnCalculator(),
  });

  List<ForwardHorizonResult> analyze(
    List<MarketObservation> observations, {
    List<int> horizons = const [1, 3, 5, 10, 20],
  }) {
    final results = <ForwardHorizonResult>[];

    for (final horizon in horizons) {
      var buyCount = 0;
      var sellCount = 0;
      var buyReturn = 0.0;
      var sellReturn = 0.0;
      var buyCorrect = 0;
      var sellCorrect = 0;

      for (var i = 0; i < observations.length; i++) {
        final endIndex = i + horizon;

        if (endIndex >= observations.length) {
          break;
        }

        final signal = engine.evaluate(observations[i]);

        final forwardReturn = returnCalculator.calculate(
          observations,
          startIndex: i,
          horizon: horizon,
        );

        switch (signal.direction) {
          case SignalDirection.buy:
            buyCount++;
            buyReturn += forwardReturn;

            if (forwardReturn > 0) {
              buyCorrect++;
            }

          case SignalDirection.sell:
            sellCount++;

            final shortReturn = -forwardReturn;

            sellReturn += shortReturn;

            if (shortReturn > 0) {
              sellCorrect++;
            }

          case SignalDirection.wait:
            break;
        }
      }

      results.add(
        ForwardHorizonResult(
          horizonDays: horizon,
          buySignals: buyCount,
          sellSignals: sellCount,
          buyAverageReturnPercent:
              buyCount == 0 ? 0 : buyReturn / buyCount,
          sellAverageReturnPercent:
              sellCount == 0 ? 0 : sellReturn / sellCount,
          buyHitRate:
              buyCount == 0 ? 0 : buyCorrect / buyCount,
          sellHitRate:
              sellCount == 0 ? 0 : sellCorrect / sellCount,
        ),
      );
    }

    return List.unmodifiable(results);
  }
}
