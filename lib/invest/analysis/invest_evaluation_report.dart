import '../backtest/baseline_analysis.dart';
import '../backtest/economic_backtest.dart';
import '../backtest/position_backtest.dart';
import 'conditional_baseline_analysis.dart';
import 'forward_horizon_analysis.dart';
import 'out_of_sample_analysis.dart';
import 'regime_analysis.dart';

/// Immutable aggregation of the results produced by Atlas Invest analysis.
///
/// This class does not calculate or transform metrics. It provides a single
/// evaluation boundary for consumers that need the complete result of an
/// Invest analysis run.
class InvestEvaluationReport {
  InvestEvaluationReport({
    required this.baseline,
    required this.economic,
    required this.position,
    required List<ConditionalHorizonResult> conditional,
    required List<ForwardHorizonResult> forward,
    required List<RegimeHorizonResult> regime,
    required this.outOfSample,
  })  : conditional = List.unmodifiable(conditional),
        forward = List.unmodifiable(forward),
        regime = List.unmodifiable(regime);

  final BaselineAnalysis baseline;
  final EconomicBacktestResult economic;
  final PositionBacktestResult position;
  final List<ConditionalHorizonResult> conditional;
  final List<ForwardHorizonResult> forward;
  final List<RegimeHorizonResult> regime;
  final OutOfSampleResult outOfSample;
}
