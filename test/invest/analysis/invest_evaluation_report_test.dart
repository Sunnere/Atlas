import 'package:atlas/invest/analysis/conditional_baseline_analysis.dart';
import 'package:atlas/invest/analysis/forward_horizon_analysis.dart';
import 'package:atlas/invest/analysis/invest_evaluation_report.dart';
import 'package:atlas/invest/analysis/out_of_sample_analysis.dart';
import 'package:atlas/invest/analysis/regime_analysis.dart';
import 'package:atlas/invest/backtest/baseline_analysis.dart';
import 'package:atlas/invest/backtest/economic_backtest.dart';
import 'package:atlas/invest/backtest/position_backtest.dart';
import 'package:test/test.dart';

void main() {
  test('aggregates the complete Invest evaluation', () {
    const baseline = BaselineAnalysis(
      buy: SignalAnalysis(
        count: 10,
        correct: 6,
        incorrect: 4,
        averageForwardReturnPercent: 1.2,
      ),
      sell: SignalAnalysis(
        count: 8,
        correct: 5,
        incorrect: 3,
        averageForwardReturnPercent: 0.8,
      ),
      waitSignals: 12,
    );

    const economic = EconomicBacktestResult(
      strategyReturnPercent: 12.0,
      buyAndHoldReturnPercent: 9.0,
      maxDrawdownPercent: -4.0,
      tradeCount: 20,
      signalCount: 20,
      totalCostsPercent: 1.4,
    );

    const position = PositionBacktestResult(
      strategyReturnPercent: 14.0,
      buyAndHoldReturnPercent: 9.0,
      maxDrawdownPercent: -3.5,
      tradeCount: 12,
      signalCount: 20,
      totalCostsPercent: 0.84,
      longDays: 40,
      shortDays: 15,
      flatDays: 45,
    );

    const conditional = [
      ConditionalHorizonResult(
        horizonDays: 5,
        buySignals: 10,
        nonBuySignals: 20,
        sellSignals: 8,
        nonSellSignals: 22,
        buyAverageReturnPercent: 1.5,
        nonBuyAverageReturnPercent: 0.5,
        sellAverageReturnPercent: 1.1,
        nonSellAverageReturnPercent: 0.2,
      ),
    ];

    const forward = [
      ForwardHorizonResult(
        horizonDays: 5,
        buySignals: 10,
        sellSignals: 8,
        buyAverageReturnPercent: 1.5,
        sellAverageReturnPercent: 1.1,
        buyHitRate: 0.6,
        sellHitRate: 0.625,
      ),
    ];

    const regime = [
      RegimeHorizonResult(
        regime: MarketRegime.bull,
        horizonDays: 5,
        observations: 50,
        buySignals: 10,
        sellSignals: 8,
        nonBuySignals: 40,
        nonSellSignals: 42,
        buyAverageReturnPercent: 1.5,
        nonBuyAverageReturnPercent: 0.5,
        sellAverageReturnPercent: 1.1,
        nonSellAverageReturnPercent: 0.2,
      ),
    ];

    const outOfSample = OutOfSampleResult(
      dataset: 'NVDA-OOS',
      observations: 100,
      buySignals: 10,
      nonBuySignals: 90,
      sellSignals: 8,
      nonSellSignals: 92,
      buyAverageReturnPercent: 1.4,
      nonBuyAverageReturnPercent: 0.3,
      sellAverageReturnPercent: 1.0,
      nonSellAverageReturnPercent: 0.2,
    );

    final report = InvestEvaluationReport(
      baseline: baseline,
      economic: economic,
      position: position,
      conditional: conditional,
      forward: forward,
      regime: regime,
      outOfSample: outOfSample,
    );

    expect(report.baseline, same(baseline));
    expect(report.economic, same(economic));
    expect(report.position, same(position));
    expect(report.conditional, hasLength(1));
    expect(report.forward, hasLength(1));
    expect(report.regime, hasLength(1));
    expect(report.outOfSample, same(outOfSample));

    expect(
      () => report.conditional.add(conditional.single),
      throwsUnsupportedError,
    );

    expect(
      () => report.forward.add(forward.single),
      throwsUnsupportedError,
    );

    expect(
      () => report.regime.add(regime.single),
      throwsUnsupportedError,
    );
  });
}
