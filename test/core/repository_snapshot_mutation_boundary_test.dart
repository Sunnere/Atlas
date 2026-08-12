import 'dart:io';

import 'package:atlas/core/models/repository_item.dart';
import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/scanner/repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('RepositorySnapshot mutation boundaries', () {
    late Directory repository;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'atlas_snapshot_boundary_test_',
      );

      Directory('${repository.path}/lib/models').createSync(recursive: true);
      Directory('${repository.path}/test').createSync(recursive: true);

      File('${repository.path}/lib/models/example.dart').writeAsStringSync(
        'class Example {}',
      );

      File('${repository.path}/test/example_test.dart').writeAsStringSync(
        'void main() {}',
      );
    });

    tearDown(() {
      if (repository.existsSync()) {
        repository.deleteSync(recursive: true);
      }
    });

    test('snapshot protects imports from list mutation', () async {
      final scanner = RepositoryScanner();
      final repositoryModel = await scanner.scan(repository.path);

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        imports: scanner.imports,
        inventory: scanner.inventory,
        graph: scanner.graph,
        stats: scanner.stats,
      );

      expect(
        () => snapshot.imports.clear(),
        throwsUnsupportedError,
      );
    });

    test('snapshot protects inventory from collection mutation', () async {
      final scanner = RepositoryScanner();
      final repositoryModel = await scanner.scan(repository.path);

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        imports: scanner.imports,
        inventory: scanner.inventory,
        graph: scanner.graph,
        stats: scanner.stats,
      );

      expect(
        () => snapshot.inventory.items.clear(),
        throwsUnsupportedError,
      );

      expect(
        () => snapshot.inventory.items.add(
          RepositoryItem(
            path: 'lib/models/injected.dart',
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('snapshot inventory is independent from scanner inventory', () async {
      final scanner = RepositoryScanner();
      final repositoryModel = await scanner.scan(repository.path);

      final originalInventory = scanner.inventory!;

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        imports: scanner.imports,
        inventory: originalInventory,
        graph: scanner.graph,
        stats: scanner.stats,
      );

      final before = snapshot.inventory.totalFiles;

      originalInventory.add(
        RepositoryItem(
          path: 'lib/models/injected.dart',
        ),
      );

      expect(snapshot.inventory.totalFiles, before);
      expect(
        snapshot.inventory.models.any(
          (item) => item.path == 'lib/models/injected.dart',
        ),
        isFalse,
      );
    });
  });
}
