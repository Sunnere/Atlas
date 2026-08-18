import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';

typedef SignalEvaluator = SignalDirection Function(
  MarketObservation observation,
);

class FixedHorizonBacktestConfig {
  final int horizonDays;
  final double transactionCostPercent;
  final double slippagePercent;
  final double initialCapital;

  const FixedHorizonBacktestConfig({
    this.horizonDays = 20,
    this.transactionCostPercent = 0.05,
    this.slippagePercent = 0.02,
    this.initialCapital = 100000.0,
  });

  double get tradeCostPercent =>
      transactionCostPercent + slippagePercent;
}

class FixedHorizonBacktestResult {
  final double initialCapital;
  final double finalCapital;
  final double strategyReturnPercent;
  final double buyAndHoldReturnPercent;
  final double outperformancePercent;
  final double maxDrawdownPercent;

  final int signalCount;
  final int tradeCount;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double totalCostsPercent;

  const FixedHorizonBacktestResult({
    required this.initialCapital,
    required this.finalCapital,
    required this.strategyReturnPercent,
    required this.buyAndHoldReturnPercent,
    required this.outperformancePercent,
    required this.maxDrawdownPercent,
    required this.signalCount,
    required this.tradeCount,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.totalCostsPercent,
  });
}

class AtlasFixedHorizonBacktest {
  final AtlasSignalEngine engine;
  final FixedHorizonBacktestConfig config;
  final SignalEvaluator? signalEvaluator;

  const AtlasFixedHorizonBacktest({
    this.engine = const AtlasSignalEngine(),
    this.config = const FixedHorizonBacktestConfig(),
    this.signalEvaluator,
  });

  SignalDirection evaluateSignal(
    MarketObservation observation,
  ) {
    if (signalEvaluator != null) {
      return signalEvaluator!(observation);
    }

    return engine.evaluate(observation).direction;
  }

  FixedHorizonBacktestResult run(
    List<MarketObservation> observations,
  ) {
    if (observations.length < config.horizonDays + 1) {
      throw ArgumentError(
        'Not enough observations for the configured horizon.',
      );
    }

    var capital = config.initialCapital;
    var peakCapital = capital;
    var maxDrawdownPercent = 0.0;

    var buyAndHoldEquity = 1.0;

    var signalCount = 0;
    var tradeCount = 0;
    var winningTrades = 0;
    var losingTrades = 0;
    var totalCostsPercent = 0.0;

    var i = 0;

    while (i + config.horizonDays < observations.length) {
      final observation = observations[i];

      final nextReturn =
          observations[i + 1].priceChangePercent / 100.0;

      buyAndHoldEquity *= 1.0 + nextReturn;

      final direction = evaluateSignal(observation);

      if (direction != SignalDirection.sell) {
        i++;
        continue;
      }

      signalCount++;

      var tradeGrowth = 1.0;

      for (var j = i + 1;
          j <= i + config.horizonDays;
          j++) {
        final dailyReturn =
            observations[j].priceChangePercent / 100.0;

        tradeGrowth *= 1.0 - dailyReturn;
      }

      final costMultiplier =
          1.0 - config.tradeCostPercent / 100.0;

      final tradeMultiplier =
          tradeGrowth * costMultiplier;

      final tradeReturnPercent =
          (tradeMultiplier - 1.0) * 100.0;

      capital *= tradeMultiplier;

      tradeCount++;
      totalCostsPercent += config.tradeCostPercent;

      if (tradeReturnPercent > 0) {
        winningTrades++;
      } else {
        losingTrades++;
      }

      if (capital > peakCapital) {
        peakCapital = capital;
      }

      final drawdown =
          ((capital / peakCapital) - 1.0) * 100.0;

      if (drawdown < maxDrawdownPercent) {
        maxDrawdownPercent = drawdown;
      }

      // The fixed-horizon position is now closed.
      // Move directly to the first observation after it.
      i += config.horizonDays;
    }

    final strategyReturnPercent =
        ((capital / config.initialCapital) - 1.0) * 100.0;

    final buyAndHoldReturnPercent =
        (buyAndHoldEquity - 1.0) * 100.0;

    return FixedHorizonBacktestResult(
      initialCapital: config.initialCapital,
      finalCapital: capital,
      strategyReturnPercent: strategyReturnPercent,
      buyAndHoldReturnPercent: buyAndHoldReturnPercent,
      outperformancePercent:
          strategyReturnPercent - buyAndHoldReturnPercent,
      maxDrawdownPercent: maxDrawdownPercent,
      signalCount: signalCount,
      tradeCount: tradeCount,
      winningTrades: winningTrades,
      losingTrades: losingTrades,
      winRate: tradeCount == 0
          ? 0.0
          : winningTrades / tradeCount,
      totalCostsPercent: totalCostsPercent,
    );
  }
}
