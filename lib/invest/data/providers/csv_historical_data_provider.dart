import 'dart:io';

import '../../../core/observations/market_observation.dart';
import 'historical_data_provider.dart';

class CsvHistoricalDataProvider
    implements HistoricalDataProvider {
  final String filePath;

  const CsvHistoricalDataProvider({
    required this.filePath,
  });

  @override
  Future<List<MarketObservation>> load({
    required String instrument,
    required DateTime from,
    required DateTime to,
  }) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw StateError(
        'Historical data file not found: $filePath',
      );
    }

    final lines = await file.readAsLines();

    if (lines.isEmpty) {
      return const [];
    }

    final header = lines.first.split(',');

    final dateIndex = header.indexOf('timestamp');
    final changeIndex =
        header.indexOf('priceChangePercent');
    final volumeIndex =
        header.indexOf('volumeRatio');

    if (dateIndex < 0 ||
        changeIndex < 0 ||
        volumeIndex < 0) {
      throw const FormatException(
        'CSV must contain timestamp, priceChangePercent and volumeRatio.',
      );
    }

    final observations = <MarketObservation>[];

    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) {
        continue;
      }

      final values = line.split(',');

      if (values.length < header.length) {
        throw const FormatException(
          'CSV row contains fewer columns than the header.',
        );
      }

      final timestamp =
          DateTime.parse(values[dateIndex].trim());

      if (timestamp.isBefore(from) ||
          timestamp.isAfter(to)) {
        continue;
      }

      observations.add(
        MarketObservation(
          instrument: instrument,
          timestamp: timestamp,
          priceChangePercent:
              double.parse(values[changeIndex].trim()),
          volumeRatio:
              double.parse(values[volumeIndex].trim()),
        ),
      );
    }

    return List.unmodifiable(observations);
  }
}
