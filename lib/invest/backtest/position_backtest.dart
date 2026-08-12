import '../ase/atlas_signal_engine.dart';
import '../../core/contracts/signal_contract.dart';
import '../../core/observations/market_observation.dart';

enum PositionState {
  flat,
  long,
  short,
}

class PositionBacktestConfig {
  final double transactionCostPercent;
  final double slippagePercent;

  const PositionBacktestConfig({
    this.transactionCostPercent = 0.05,
    this.slippagePercent = 0.02,
  });

  double get roundTripCostPercent =>
      transactionCostPercent + slippagePercent;
}

class PositionBacktestResult {
  final double strategyReturnPercent;
  final double buyAndHoldReturnPercent;
  final double maxDrawdownPercent;
  final int tradeCount;
  final int signalCount;
  final double totalCostsPercent;
  final int longDays;
  final int shortDays;
  final int flatDays;

  const PositionBacktestResult({
    required this.strategyReturnPercent,
    required this.buyAndHoldReturnPercent,
    required this.maxDrawdownPercent,
    required this.tradeCount,
    required this.signalCount,
    required this.totalCostsPercent,
    required this.longDays,
    required this.shortDays,
    required this.flatDays,
  });

  double get outperformancePercent =>
      strategyReturnPercent - buyAndHoldReturnPercent;
}

class AtlasPositionBacktest {
  final AtlasSignalEngine engine;
  final PositionBacktestConfig config;

  const AtlasPositionBacktest({
    this.engine = const AtlasSignalEngine(),
    this.config = const PositionBacktestConfig(),
  });

  PositionBacktestResult run(
    List<MarketObservation> observations,
  ) {
    if (observations.length < 2) {
      throw ArgumentError(
        'At least two observations are required.',
      );
    }

    var position = PositionState.flat;

    var strategyEquity = 1.0;
    var buyAndHoldEquity = 1.0;
    var peakEquity = 1.0;
    var maxDrawdown = 0.0;

    var tradeCount = 0;
    var signalCount = 0;
    var totalCosts = 0.0;

    var longDays = 0;
    var shortDays = 0;
    var flatDays = 0;

    for (var i = 0; i < observations.length - 1; i++) {
      final observation = observations[i];
      final nextReturn =
          observations[i + 1].priceChangePercent / 100.0;

      buyAndHoldEquity *= 1.0 + nextReturn;

      final signal = engine.evaluate(observation);

      PositionState targetPosition = position;

      switch (signal.direction) {
        case SignalDirection.buy:
          signalCount++;
          targetPosition = PositionState.long;

        case SignalDirection.sell:
          signalCount++;
          targetPosition = PositionState.short;

        case SignalDirection.wait:
          targetPosition = position;
      }

      if (targetPosition != position) {
        tradeCount++;

        final cost =
            config.roundTripCostPercent / 100.0;

        strategyEquity *= 1.0 - cost;
        totalCosts += config.roundTripCostPercent;

        position = targetPosition;
      }

      switch (position) {
        case PositionState.long:
          longDays++;
          strategyEquity *= 1.0 + nextReturn;

        case PositionState.short:
          shortDays++;
          strategyEquity *= 1.0 - nextReturn;

        case PositionState.flat:
          flatDays++;
      }

      if (strategyEquity > peakEquity) {
        peakEquity = strategyEquity;
      }

      final drawdown =
          ((strategyEquity / peakEquity) - 1.0) * 100.0;

      if (drawdown < maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }

    return PositionBacktestResult(
      strategyReturnPercent:
          (strategyEquity - 1.0) * 100.0,
      buyAndHoldReturnPercent:
          (buyAndHoldEquity - 1.0) * 100.0,
      maxDrawdownPercent: maxDrawdown,
      tradeCount: tradeCount,
      signalCount: signalCount,
      totalCostsPercent: totalCosts,
      longDays: longDays,
      shortDays: shortDays,
      flatDays: flatDays,
    );
  }
}
