import 'dart:io';

import 'import_reference.dart';
import 'import_type.dart';

/// Scans Dart files for import statements.
class ImportScanner {
  const ImportScanner();

  List<ImportReference> scan(File file) {
    final imports = <ImportReference>[];

    if (!file.path.endsWith('.dart')) {
      return imports;
    }

    for (final line in file.readAsLinesSync()) {
      final trimmed = line.trimLeft();

      if (!trimmed.startsWith('import ')) {
        continue;
      }

      final match = RegExp(r'''import\s+['"]([^'"]+)['"]''')
          .firstMatch(trimmed);

      if (match == null) {
        continue;
      }

      final target = match.group(1)!;

      imports.add(
        ImportReference(
          source: file.path,
          target: target,
          type: _classify(target),
        ),
      );
    }

    return imports;
  }

  ImportType _classify(String target) {
    if (target.startsWith('dart:')) {
      return ImportType.dartSdk;
    }

    if (target.startsWith('package:flutter/')) {
      return ImportType.flutter;
    }

    if (target.startsWith('package:')) {
      return ImportType.package;
    }

    return ImportType.local;
  }
}
