import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';

class EconomicBacktestResult {
  final double strategyReturnPercent;
  final double buyAndHoldReturnPercent;
  final double maxDrawdownPercent;
  final int tradeCount;
  final int signalCount;
  final double totalCostsPercent;

  const EconomicBacktestResult({
    required this.strategyReturnPercent,
    required this.buyAndHoldReturnPercent,
    required this.maxDrawdownPercent,
    required this.tradeCount,
    required this.signalCount,
    required this.totalCostsPercent,
  });

  double get outperformancePercent =>
      strategyReturnPercent - buyAndHoldReturnPercent;
}

class EconomicBacktestConfig {
  final double transactionCostPercent;
  final double slippagePercent;

  const EconomicBacktestConfig({
    this.transactionCostPercent = 0.05,
    this.slippagePercent = 0.02,
  });
}

class AtlasEconomicBacktest {
  final AtlasSignalEngine engine;
  final EconomicBacktestConfig config;

  const AtlasEconomicBacktest({
    this.engine = const AtlasSignalEngine(),
    this.config = const EconomicBacktestConfig(),
  });

  EconomicBacktestResult run(
    List<MarketObservation> observations,
  ) {
    if (observations.length < 2) {
      throw ArgumentError(
        'At least two observations are required.',
      );
    }

    var strategyEquity = 1.0;
    var buyAndHoldEquity = 1.0;
    var peakEquity = 1.0;
    var maxDrawdown = 0.0;

    var tradeCount = 0;
    var signalCount = 0;
    var totalCosts = 0.0;

    for (var i = 0; i < observations.length - 1; i++) {
      final observation = observations[i];
      final nextReturn =
          observations[i + 1].priceChangePercent / 100.0;

      buyAndHoldEquity *= 1.0 + nextReturn;

      final signal = engine.evaluate(observation);

      var strategyReturn = 0.0;
      var traded = false;

      switch (signal.direction) {
        case SignalDirection.buy:
          strategyReturn = nextReturn;
          traded = true;

        case SignalDirection.sell:
          strategyReturn = -nextReturn;
          traded = true;

        case SignalDirection.wait:
          strategyReturn = 0.0;
      }

      if (traded) {
        signalCount++;
        tradeCount++;

        final cost =
            (config.transactionCostPercent +
                    config.slippagePercent) /
                100.0;

        strategyReturn -= cost;
        totalCosts +=
            config.transactionCostPercent +
                config.slippagePercent;
      }

      strategyEquity *= 1.0 + strategyReturn;

      if (strategyEquity > peakEquity) {
        peakEquity = strategyEquity;
      }

      final drawdown =
          ((strategyEquity / peakEquity) - 1.0) * 100.0;

      if (drawdown < maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }

    return EconomicBacktestResult(
      strategyReturnPercent:
          (strategyEquity - 1.0) * 100.0,
      buyAndHoldReturnPercent:
          (buyAndHoldEquity - 1.0) * 100.0,
      maxDrawdownPercent: maxDrawdown,
      tradeCount: tradeCount,
      signalCount: signalCount,
      totalCostsPercent: totalCosts,
    );
  }
}
