import 'import_reference.dart';
import 'import_type.dart';

class ImportSummary {
  const ImportSummary({
    required this.local,
    required this.package,
    required this.flutter,
    required this.dartSdk,
  });

  final int local;
  final int package;
  final int flutter;
  final int dartSdk;

  int get total => local + package + flutter + dartSdk;

  factory ImportSummary.fromImports(
    List<ImportReference> imports,
  ) {
    var local = 0;
    var package = 0;
    var flutter = 0;
    var dartSdk = 0;

    for (final import in imports) {
      switch (import.type) {
        case ImportType.local:
          local++;
          break;
        case ImportType.package:
          package++;
          break;
        case ImportType.flutter:
          flutter++;
          break;
        case ImportType.dartSdk:
          dartSdk++;
          break;
      }
    }

    return ImportSummary(
      local: local,
      package: package,
      flutter: flutter,
      dartSdk: dartSdk,
    );
  }
}
