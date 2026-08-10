import '../../core/observations/market_observation.dart';

class HistoricalMarketDataAdapter {
  const HistoricalMarketDataAdapter();

  List<MarketObservation> fromRows(
    List<Map<String, String>> rows,
  ) {
    return rows.map((row) {
      return MarketObservation(
        instrument: row['instrument']!,
        timestamp: DateTime.parse(row['timestamp']!),
        priceChangePercent:
            double.parse(row['priceChangePercent']!),
        volumeRatio:
            double.parse(row['volumeRatio']!),
      );
    }).toList(growable: false);
  }
}
