import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';
import '../temporal/evaluation_window.dart';

class EconomicWalkForwardResult {
  final String fold;
  final int horizonDays;
  final int observations;
  final int trades;
  final double grossReturnPercent;
  final double totalCostsPercent;
  final double netReturnPercent;
  final double averageTradeReturnPercent;
  final double winRate;
  final double maxDrawdownPercent;

  const EconomicWalkForwardResult({
    required this.fold,
    required this.horizonDays,
    required this.observations,
    required this.trades,
    required this.grossReturnPercent,
    required this.totalCostsPercent,
    required this.netReturnPercent,
    required this.averageTradeReturnPercent,
    required this.winRate,
    required this.maxDrawdownPercent,
  });
}

class AtlasWalkForwardEconomicAnalyzer {
  final AtlasSignalEngine engine;
  final double costPerTradePercent;

  const AtlasWalkForwardEconomicAnalyzer({
    this.engine = const AtlasSignalEngine(),
    this.costPerTradePercent = 0.07,
  });

  EconomicWalkForwardResult analyzeFold(
    List<MarketObservation> observations, {
    required String fold,
    required DateTime testStart,
    required DateTime testEnd,
    int horizonDays = 20,
  }) {
    var observationsCount = 0;
    var trades = 0;
    var grossReturn = 0.0;
    var totalCosts = 0.0;
    var wins = 0;

    var equity = 1.0;
    var peakEquity = 1.0;
    var maxDrawdown = 0.0;

    final timestamps = observations
        .map((observation) => observation.timestamp)
        .toList(growable: false);

    for (var i = 0; i < observations.length; i++) {
      final timestamp = observations[i].timestamp;

      if (timestamp.isBefore(testStart) ||
          !timestamp.isBefore(testEnd)) {
        continue;
      }

      EvaluationWindow window;

      try {
        window = EvaluationWindow.create(
          timestamps: timestamps,
          signalIndex: i,
          horizon: horizonDays,
          boundaryStart: testStart,
          boundaryEnd: testEnd,
        );
      } on StateError {
        continue;
      }

      observationsCount++;

      final signal = engine.evaluate(observations[i]);

      if (signal.direction != SignalDirection.sell) {
        continue;
      }

      var tradeGrowth = 1.0;

      for (final index in window.outcomeIndices) {
        tradeGrowth *=
            1.0 -
            observations[index].priceChangePercent / 100.0;
      }

      final grossTradeReturn =
          (tradeGrowth - 1.0) * 100.0;

      final netTradeReturn =
          grossTradeReturn - costPerTradePercent;

      trades++;
      grossReturn += grossTradeReturn;
      totalCosts += costPerTradePercent;

      if (netTradeReturn > 0) {
        wins++;
      }

      equity *= 1.0 + netTradeReturn / 100.0;

      if (equity > peakEquity) {
        peakEquity = equity;
      }

      final drawdown =
          ((equity / peakEquity) - 1.0) * 100.0;

      if (drawdown < maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }

    final netReturn = grossReturn - totalCosts;

    return EconomicWalkForwardResult(
      fold: fold,
      horizonDays: horizonDays,
      observations: observationsCount,
      trades: trades,
      grossReturnPercent: grossReturn,
      totalCostsPercent: totalCosts,
      netReturnPercent: netReturn,
      averageTradeReturnPercent:
          trades == 0 ? 0 : netReturn / trades,
      winRate:
          trades == 0 ? 0 : wins / trades,
      maxDrawdownPercent: maxDrawdown,
    );
  }
}
