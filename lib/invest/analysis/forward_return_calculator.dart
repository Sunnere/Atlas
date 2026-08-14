import '../../core/observations/market_observation.dart';

class ForwardReturnCalculator {
  const ForwardReturnCalculator();

  double calculate(
    List<MarketObservation> observations, {
    required int startIndex,
    required int horizon,
  }) {
    final endIndex = startIndex + horizon;

    if (endIndex >= observations.length) {
      throw RangeError(
        'Horizon extends beyond available observations.',
      );
    }

    var compoundedReturn = 1.0;

    for (var index = startIndex + 1;
        index <= endIndex;
        index++) {
      compoundedReturn *=
          1.0 + observations[index].priceChangePercent / 100.0;
    }

    return (compoundedReturn - 1.0) * 100.0;
  }
}
