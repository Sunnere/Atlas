import 'package:test/test.dart';

import '../../../lib/invest/data/historical_market_data.dart';

void main() {
  group('HistoricalMarketDataAdapter', () {
    test('converts historical rows into MarketObservation', () {
      const adapter = HistoricalMarketDataAdapter();

      final observations = adapter.fromRows([
        {
          'instrument': 'NVDA',
          'timestamp': '2026-01-05T00:00:00Z',
          'priceChangePercent': '3.2',
          'volumeRatio': '2.1',
        },
        {
          'instrument': 'NVDA',
          'timestamp': '2026-01-06T00:00:00Z',
          'priceChangePercent': '-2.4',
          'volumeRatio': '1.8',
        },
      ]);

      expect(observations, hasLength(2));

      expect(observations[0].instrument, 'NVDA');
      expect(observations[0].priceChangePercent, 3.2);
      expect(observations[0].volumeRatio, 2.1);

      expect(observations[1].priceChangePercent, -2.4);
      expect(observations[1].volumeRatio, 1.8);
    });
  });
}
