import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import 'forward_return_calculator.dart';

class OutOfSampleResult {
  final String dataset;
  final int observations;

  final int buySignals;
  final int nonBuySignals;
  final int sellSignals;
  final int nonSellSignals;

  final double buyAverageReturnPercent;
  final double nonBuyAverageReturnPercent;
  final double sellAverageReturnPercent;
  final double nonSellAverageReturnPercent;

  const OutOfSampleResult({
    required this.dataset,
    required this.observations,
    required this.buySignals,
    required this.nonBuySignals,
    required this.sellSignals,
    required this.nonSellSignals,
    required this.buyAverageReturnPercent,
    required this.nonBuyAverageReturnPercent,
    required this.sellAverageReturnPercent,
    required this.nonSellAverageReturnPercent,
  });

  double get buyUpliftPercent =>
      buyAverageReturnPercent - nonBuyAverageReturnPercent;

  double get sellUpliftPercent =>
      sellAverageReturnPercent - nonSellAverageReturnPercent;
}

class AtlasOutOfSampleAnalyzer {
  final AtlasSignalEngine engine;
  final ForwardReturnCalculator returnCalculator;

  const AtlasOutOfSampleAnalyzer({
    this.engine = const AtlasSignalEngine(),
    this.returnCalculator = const ForwardReturnCalculator(),
  });

  OutOfSampleResult analyze(
    List<MarketObservation> observations, {
    required String dataset,
    List<int> horizons = const [1, 3, 5, 10, 20],
  }) {
    if (horizons.length != 1) {
      throw ArgumentError(
        'Out-of-sample analysis currently requires exactly one horizon.',
      );
    }

    final horizon = horizons.first;

    var buySignals = 0;
    var nonBuySignals = 0;
    var sellSignals = 0;
    var nonSellSignals = 0;

    var buyReturn = 0.0;
    var nonBuyReturn = 0.0;
    var sellReturn = 0.0;
    var nonSellReturn = 0.0;

    for (var i = 0; i < observations.length; i++) {
      final endIndex = i + horizon;

      if (endIndex >= observations.length) {
        break;
      }

      final forwardReturn = returnCalculator.calculate(
        observations,
        startIndex: i,
        horizon: horizon,
      );

      final signal = engine.evaluate(observations[i]);

      final isBuy =
          signal.direction == SignalDirection.buy;

      final isSell =
          signal.direction == SignalDirection.sell;

      if (isBuy) {
        buySignals++;
        buyReturn += forwardReturn;
      } else {
        nonBuySignals++;
        nonBuyReturn += forwardReturn;
      }

      if (isSell) {
        sellSignals++;
        sellReturn += -forwardReturn;
      } else {
        nonSellSignals++;
        nonSellReturn += -forwardReturn;
      }
    }

    return OutOfSampleResult(
      dataset: dataset,
      observations: observations.length,
      buySignals: buySignals,
      nonBuySignals: nonBuySignals,
      sellSignals: sellSignals,
      nonSellSignals: nonSellSignals,
      buyAverageReturnPercent:
          buySignals == 0 ? 0 : buyReturn / buySignals,
      nonBuyAverageReturnPercent:
          nonBuySignals == 0
              ? 0
              : nonBuyReturn / nonBuySignals,
      sellAverageReturnPercent:
          sellSignals == 0 ? 0 : sellReturn / sellSignals,
      nonSellAverageReturnPercent:
          nonSellSignals == 0
              ? 0
              : nonSellReturn / nonSellSignals,
    );
  }
}
