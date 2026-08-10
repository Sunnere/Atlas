import 'dart:io';

import 'package:test/test.dart';

import '../../../../lib/invest/data/providers/csv_historical_data_provider.dart';

void main() {
  test('loads historical observations from CSV', () async {
    final file = File(
      '${Directory.systemTemp.path}/atlas_historical_test.csv',
    );

    await file.writeAsString(
      'timestamp,priceChangePercent,volumeRatio\n'
      '2026-01-05T00:00:00Z,3.2,2.1\n'
      '2026-01-06T00:00:00Z,-2.4,1.8\n'
      '2026-01-07T00:00:00Z,0.4,1.1\n',
    );

    final provider = CsvHistoricalDataProvider(
      filePath: file.path,
    );

    final observations = await provider.load(
      instrument: 'NVDA',
      from: DateTime.utc(2026, 1, 1),
      to: DateTime.utc(2026, 1, 31),
    );

    expect(observations, hasLength(3));
    expect(observations[0].instrument, 'NVDA');
    expect(observations[0].priceChangePercent, 3.2);
    expect(observations[1].priceChangePercent, -2.4);
    expect(observations[2].volumeRatio, 1.1);

    await file.delete();
  });
}
