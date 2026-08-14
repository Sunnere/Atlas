import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import 'forward_return_calculator.dart';

class WalkForwardFold {
  final String name;
  final DateTime testStart;
  final DateTime testEnd;

  const WalkForwardFold({
    required this.name,
    required this.testStart,
    required this.testEnd,
  });
}

class WalkForwardResult {
  final String fold;
  final int horizonDays;
  final int observations;
  final int buySignals;
  final int sellSignals;
  final int nonBuySignals;
  final int nonSellSignals;

  final double buyAverageReturnPercent;
  final double nonBuyAverageReturnPercent;
  final double sellAverageReturnPercent;
  final double nonSellAverageReturnPercent;

  const WalkForwardResult({
    required this.fold,
    required this.horizonDays,
    required this.observations,
    required this.buySignals,
    required this.sellSignals,
    required this.nonBuySignals,
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

class AtlasWalkForwardAnalyzer {
  final AtlasSignalEngine engine;
  final ForwardReturnCalculator returnCalculator;

  const AtlasWalkForwardAnalyzer({
    this.engine = const AtlasSignalEngine(),
    this.returnCalculator = const ForwardReturnCalculator(),
  });

  WalkForwardResult analyzeFold(
    List<MarketObservation> observations, {
    required WalkForwardFold fold,
    required int horizonDays,
  }) {
    var observationsCount = 0;
    var buySignals = 0;
    var sellSignals = 0;
    var nonBuySignals = 0;
    var nonSellSignals = 0;

    var buyReturn = 0.0;
    var nonBuyReturn = 0.0;
    var sellReturn = 0.0;
    var nonSellReturn = 0.0;

    for (var i = 0;
        i + horizonDays < observations.length;
        i++) {
      final timestamp = observations[i].timestamp;

      if (timestamp.isBefore(fold.testStart) ||
          !timestamp.isBefore(fold.testEnd)) {
        continue;
      }

      observationsCount++;

      final forwardReturn = returnCalculator.calculate(
        observations,
        startIndex: i,
        horizon: horizonDays,
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

    return WalkForwardResult(
      fold: fold.name,
      horizonDays: horizonDays,
      observations: observationsCount,
      buySignals: buySignals,
      sellSignals: sellSignals,
      nonBuySignals: nonBuySignals,
      nonSellSignals: nonSellSignals,
      buyAverageReturnPercent:
          buySignals == 0
              ? 0
              : buyReturn / buySignals,
      nonBuyAverageReturnPercent:
          nonBuySignals == 0
              ? 0
              : nonBuyReturn / nonBuySignals,
      sellAverageReturnPercent:
          sellSignals == 0
              ? 0
              : sellReturn / sellSignals,
      nonSellAverageReturnPercent:
          nonSellSignals == 0
              ? 0
              : nonSellReturn / nonSellSignals,
    );
  }

  List<WalkForwardResult> analyze(
    List<MarketObservation> observations, {
    required List<WalkForwardFold> folds,
    List<int> horizons = const [3, 5, 20],
  }) {
    final results = <WalkForwardResult>[];

    for (final fold in folds) {
      for (final horizon in horizons) {
        results.add(
          analyzeFold(
            observations,
            fold: fold,
            horizonDays: horizon,
          ),
        );
      }
    }

    return List.unmodifiable(results);
  }
}
