import 'dart:io';

import 'package:atlas/scanner/repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('RepositoryScanner inventory integration', () {
    late Directory repository;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'atlas_inventory_test_',
      );

      Directory('${repository.path}/lib/models').createSync(recursive: true);
      Directory('${repository.path}/lib/services').createSync(recursive: true);
      Directory('${repository.path}/test').createSync(recursive: true);

      File('${repository.path}/lib/models/example.dart').writeAsStringSync(
        'class Example {}',
      );

      File('${repository.path}/lib/services/example_service.dart')
          .writeAsStringSync(
        'import "../models/example.dart";\n'
        'class ExampleService {}',
      );

      File('${repository.path}/test/example_test.dart').writeAsStringSync(
        'void main() {}',
      );

      File('${repository.path}/pubspec.yaml').writeAsStringSync(
        'name: atlas_inventory_test\n',
      );
    });

    tearDown(() {
      if (repository.existsSync()) {
        repository.deleteSync(recursive: true);
      }
    });

    test('builds repository inventory from scanned files', () async {
      final scanner = RepositoryScanner();

      final model = await scanner.scan(repository.path);
      final inventory = scanner.inventory;

      expect(inventory, isNotNull);
      expect(model.rootPath, repository.path);

      expect(inventory!.totalFiles, 4);
      expect(inventory.models, hasLength(1));
      expect(inventory.services, hasLength(1));
      expect(inventory.tests, hasLength(1));
      expect(inventory.configs, hasLength(1));

      expect(inventory.models.single.name, 'example.dart');
      expect(
        inventory.services.single.name,
        'example_service.dart',
      );
      expect(inventory.tests.single.name, 'example_test.dart');
      expect(inventory.configs.single.name, 'pubspec.yaml');

      expect(scanner.imports, hasLength(1));
      expect(scanner.stats, isNotNull);
      expect(scanner.stats!.dartFiles, 3);
      expect(scanner.stats!.testFiles, 1);
      expect(scanner.stats!.pubspecFiles, 1);
    });
  });
}
