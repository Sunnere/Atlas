import '../../../core/observations/market_observation.dart';

abstract interface class HistoricalDataProvider {
  Future<List<MarketObservation>> load({
    required String instrument,
    required DateTime from,
    required DateTime to,
  });
}
