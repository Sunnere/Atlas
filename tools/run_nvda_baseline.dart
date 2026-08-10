import 'dart:io';

import '../lib/core/observations/market_observation.dart';
import '../lib/core/contracts/signal_contract.dart';
import '../lib/invest/ase/atlas_signal_engine.dart';
import '../lib/invest/backtest/atlas_backtest.dart';

void main() {
  const path =
      'data/historical/normalized/nvda_observations.csv';

  final file = File(path);

  if (!file.existsSync()) {
    throw StateError(
      'Historical dataset not found: $path',
    );
  }

  final lines = file.readAsLinesSync();

  if (lines.length < 3) {
    throw StateError(
      'Not enough historical observations.',
    );
  }

  final observations = <MarketObservation>[];

  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) {
      continue;
    }

    final values = line.split(',');

    if (values.length < 3) {
      continue;
    }

    observations.add(
      MarketObservation(
        instrument: 'NVDA',
        timestamp: DateTime.parse(values[0].trim()),
        priceChangePercent:
            double.parse(values[1].trim()),
        volumeRatio:
            double.parse(values[2].trim()),
      ),
    );
  }

  if (observations.length < 2) {
    throw StateError(
      'Not enough observations for forward testing.',
    );
  }

  final cases = <BacktestCase>[];

  for (var i = 0; i < observations.length - 1; i++) {
    cases.add(
      BacktestCase(
        observation: observations[i],
        futurePriceChangePercent:
            observations[i + 1].priceChangePercent,
      ),
    );
  }

  const engine = AtlasSignalEngine();
  const backtest = AtlasBacktest();

  final result = backtest.run(cases);

  final buySignals = <MarketObservation>[];
  final sellSignals = <MarketObservation>[];
  var waitSignals = 0;

  for (final observation in observations
      .take(observations.length - 1)) {
    final signal = engine.evaluate(observation);

    switch (signal.direction) {
      case SignalDirection.buy:
        buySignals.add(observation);
      case SignalDirection.sell:
        sellSignals.add(observation);
      case SignalDirection.wait:
        waitSignals++;
    }
  }

  print('');
  print('========================================');
  print('ATLAS INVEST — NVDA BASELINE v0.1');
  print('========================================');
  print('');
  print('Observations: ${observations.length}');
  print('Evaluated:    ${result.totalSignals}');
  print('BUY signals:  ${buySignals.length}');
  print('SELL signals: ${sellSignals.length}');
  print('WAIT signals: $waitSignals');
  print('Correct:      ${result.correctSignals}');
  print('Incorrect:    ${result.incorrectSignals}');
  print(
    'Hit rate:     ${(result.hitRate * 100).toStringAsFixed(2)}%',
  );
  print('');
  print('========================================');
  print('BASELINE COMPLETE');
  print('========================================');
  print('');
}
