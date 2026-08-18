import 'swing_engine.dart';

enum MarketStructureState {
  bullish,
  bearish,
  mixed,
  insufficient,
}

class MarketStructure {
  final MarketStructureState state;
  final SwingPoint? latestHigh;
  final SwingPoint? previousHigh;
  final SwingPoint? latestLow;
  final SwingPoint? previousLow;

  const MarketStructure({
    required this.state,
    required this.latestHigh,
    required this.previousHigh,
    required this.latestLow,
    required this.previousLow,
  });
}

class AtlasMarketStructureEngine {
  const AtlasMarketStructureEngine();

  MarketStructure analyze(
    List<SwingPoint> swings,
  ) {
    final highs = swings
        .where((point) => point.type == SwingType.high)
        .toList();

    final lows = swings
        .where((point) => point.type == SwingType.low)
        .toList();

    if (highs.length < 2 || lows.length < 2) {
      return MarketStructure(
        state: MarketStructureState.insufficient,
        latestHigh: highs.isEmpty ? null : highs.last,
        previousHigh:
            highs.length < 2 ? null : highs[highs.length - 2],
        latestLow: lows.isEmpty ? null : lows.last,
        previousLow:
            lows.length < 2 ? null : lows[lows.length - 2],
      );
    }

    final previousHigh = highs[highs.length - 2];
    final latestHigh = highs.last;
    final previousLow = lows[lows.length - 2];
    final latestLow = lows.last;

    final higherHigh =
        latestHigh.classification ==
            SwingClassification.higherHigh;

    final lowerHigh =
        latestHigh.classification ==
            SwingClassification.lowerHigh;

    final higherLow =
        latestLow.classification ==
            SwingClassification.higherLow;

    final lowerLow =
        latestLow.classification ==
            SwingClassification.lowerLow;

    final state = higherHigh && higherLow
        ? MarketStructureState.bullish
        : lowerHigh && lowerLow
            ? MarketStructureState.bearish
            : MarketStructureState.mixed;

    return MarketStructure(
      state: state,
      latestHigh: latestHigh,
      previousHigh: previousHigh,
      latestLow: latestLow,
      previousLow: previousLow,
    );
  }
}
