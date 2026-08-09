class MarketObservation {
  final String instrument;
  final DateTime timestamp;
  final double priceChangePercent;
  final double volumeRatio;

  const MarketObservation({
    required this.instrument,
    required this.timestamp,
    required this.priceChangePercent,
    required this.volumeRatio,
  });
}
