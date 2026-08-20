import 'package:test/test.dart';

import 'package:atlas/core/contracts/signal_contract.dart';
import 'package:atlas/core/observations/market_observation.dart';
import 'package:atlas/invest/analysis/walk_forward_analysis.dart';
import 'package:atlas/invest/analysis/walk_forward_economic_analysis.dart';
import 'package:atlas/invest/backtest/fixed_horizon_backtest.dart';

MarketObservation observation(
  int day, {
  double priceChangePercent = 0.0,
  double volumeRatio = 1.0,
}) {
  return MarketObservation(
    instrument: 'NVDA',
    timestamp: DateTime.utc(2026, 1, day),
    priceChangePercent: priceChangePercent,
    volumeRatio: volumeRatio,
  );
}

void main() {
  group('Invest temporal integrity', () {
    test(
      'fixed-horizon backtest never evaluates an observation without a full future horizon',
      () {
        final observations = List.generate(
          6,
          (index) => observation(index + 1),
        );

        final evaluatedDays = <int>[];

        final backtest = AtlasFixedHorizonBacktest(
          config: const FixedHorizonBacktestConfig(
            horizonDays: 2,
          ),
          signalEvaluator: (current) {
            evaluatedDays.add(current.timestamp.day);
            return SignalDirection.wait;
          },
        );

        backtest.run(observations);

        expect(evaluatedDays, [1, 2, 3, 4]);
      },
    );

    test(
      'walk-forward only evaluates observations inside the test fold',
      () {
        final observations = List.generate(
          10,
          (index) => observation(index + 1),
        );

        const analyzer = AtlasWalkForwardAnalyzer();

        final result = analyzer.analyzeFold(
          observations,
          fold: WalkForwardFold(
            name: 'TEMPORAL',
            testStart: DateTime.utc(2026, 1, 4),
            testEnd: DateTime.utc(2026, 1, 8),
          ),
          horizonDays: 2,
        );

        expect(result.observations, 2);
      },
    );

    test(
      'economic walk-forward does not use data beyond the configured horizon',
      () {
        final observations = [
          observation(
            1,
            priceChangePercent: -2.0,
            volumeRatio: 2.0,
          ),
          observation(
            2,
            priceChangePercent: -2.0,
          ),
          observation(
            3,
            priceChangePercent: -3.0,
          ),
          observation(
            4,
            priceChangePercent: -50.0,
          ),
        ];

        const analyzer = AtlasWalkForwardEconomicAnalyzer(
          costPerTradePercent: 0.0,
        );

        final result = analyzer.analyzeFold(
          observations,
          fold: 'TEMPORAL',
          testStart: DateTime.utc(2026, 1, 1),
          testEnd: DateTime.utc(2026, 1, 4),
          horizonDays: 2,
        );

        expect(result.trades, 1);

        expect(
          result.grossReturnPercent,
          closeTo(5.06, 0.0001),
        );
      },
    );
  });
}
