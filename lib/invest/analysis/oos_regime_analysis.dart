import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import 'forward_return_calculator.dart';
import 'regime_analysis.dart';

class OosRegimeResult {
  final String dataset;
  final MarketRegime regime;
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

  const OosRegimeResult({
    required this.dataset,
    required this.regime,
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

class AtlasOosRegimeAnalyzer {
  final AtlasSignalEngine engine;
  final ForwardReturnCalculator returnCalculator;
  final int lookbackDays;

  const AtlasOosRegimeAnalyzer({
    this.engine = const AtlasSignalEngine(),
    this.returnCalculator = const ForwardReturnCalculator(),
    this.lookbackDays = 20,
  });

  MarketRegime regimeAt(
    List<MarketObservation> observations,
    int index,
  ) {
    if (index < lookbackDays) {
      throw ArgumentError(
        'Not enough history to classify regime.',
      );
    }

    var equity = 1.0;

    for (var i = index - lookbackDays; i < index; i++) {
      equity *=
          1.0 +
          observations[i].priceChangePercent / 100.0;
    }

    final returnPercent = (equity - 1.0) * 100.0;

    if (returnPercent > 0) {
      return MarketRegime.bull;
    }

    if (returnPercent < 0) {
      return MarketRegime.bear;
    }

    return MarketRegime.flat;
  }

  List<OosRegimeResult> analyze(
    List<MarketObservation> observations, {
    required DateTime splitDate,
    List<int> horizons = const [3, 5, 20],
  }) {
    final results = <OosRegimeResult>[];

    for (final dataset in ['TRAIN', 'TEST']) {
      for (final regime in [
        MarketRegime.bull,
        MarketRegime.bear,
      ]) {
        for (final horizon in horizons) {
          var count = 0;
          var buySignals = 0;
          var sellSignals = 0;
          var nonBuySignals = 0;
          var nonSellSignals = 0;

          var buyReturn = 0.0;
          var nonBuyReturn = 0.0;
          var sellReturn = 0.0;
          var nonSellReturn = 0.0;

          for (var i = lookbackDays;
              i + horizon < observations.length;
              i++) {
            final isTrain =
                observations[i].timestamp.isBefore(splitDate);

            if ((dataset == 'TRAIN') != isTrain) {
              continue;
            }

            if (regimeAt(observations, i) != regime) {
              continue;
            }

            count++;

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

          results.add(
            OosRegimeResult(
              dataset: dataset,
              regime: regime,
              horizonDays: horizon,
              observations: count,
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
            ),
          );
        }
      }
    }

    return List.unmodifiable(results);
  }
}
