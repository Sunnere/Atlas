import 'dart:io';

void main() {
  const inputPath = 'data/historical/raw/nvda_history.csv';
  const outputPath = 'data/historical/normalized/nvda_observations.csv';

  final input = File(inputPath);

  if (!input.existsSync()) {
    throw StateError('Input file not found: $inputPath');
  }

  final lines = input.readAsLinesSync();

  if (lines.length < 2) {
    throw StateError('Historical dataset is empty.');
  }

  final header = lines.first.split(',');

  final dateIndex = header.indexOf('Date');
  final adjustedCloseIndex = header.indexOf('Adj Close');
  final volumeIndex = header.indexOf('Volume');

  if (dateIndex < 0 ||
      adjustedCloseIndex < 0 ||
      volumeIndex < 0) {
    throw const FormatException(
      'Expected Date, Adj Close and Volume columns.',
    );
  }

  final rows = <_Row>[];

  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) {
      continue;
    }

    final values = line.split(',');

    if (values.length < header.length) {
      continue;
    }

    rows.add(
      _Row(
        date: values[dateIndex].trim(),
        adjustedClose:
            double.parse(values[adjustedCloseIndex].trim()),
        volume: double.parse(values[volumeIndex].trim()),
      ),
    );
  }

  final output = StringBuffer()
    ..writeln(
      'timestamp,priceChangePercent,volumeRatio',
    );

  for (var i = 1; i < rows.length; i++) {
    final current = rows[i];
    final previous = rows[i - 1];

    final priceChange =
        ((current.adjustedClose / previous.adjustedClose) - 1) * 100;

    final start = i >= 20 ? i - 20 : 0;
    final volumeWindow = rows.sublist(start, i);

    final averageVolume =
        volumeWindow.fold<double>(
              0,
              (sum, row) => sum + row.volume,
            ) /
            volumeWindow.length;

    final volumeRatio =
        averageVolume == 0
            ? 0
            : current.volume / averageVolume;

    output.writeln(
      '${current.date},'
      '${priceChange.toStringAsFixed(6)},'
      '${volumeRatio.toStringAsFixed(6)}',
    );
  }

  File(outputPath).writeAsStringSync(output.toString());

  print('Normalized ${rows.length} historical rows.');
  print('Output: $outputPath');
}

class _Row {
  final String date;
  final double adjustedClose;
  final double volume;

  const _Row({
    required this.date,
    required this.adjustedClose,
    required this.volume,
  });
}
