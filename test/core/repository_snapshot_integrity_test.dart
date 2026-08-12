import 'dart:io';

import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/scanner/repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('RepositorySnapshot integrity', () {
    late Directory repository;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'atlas_snapshot_test_',
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

    test('preserves scanner output in the snapshot', () async {
      final scanner = RepositoryScanner();

      final repositoryModel = await scanner.scan(repository.path);

      final originalImports = List.of(scanner.imports);
      final originalInventory = scanner.inventory;
      final originalGraph = scanner.graph;
      final originalStats = scanner.stats;

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        imports: scanner.imports,
        inventory: scanner.inventory,
        graph: scanner.graph,
        stats: scanner.stats,
      );

      expect(snapshot.repository.rootPath, repositoryModel.rootPath);
      expect(snapshot.repository.totalFiles, repositoryModel.totalFiles);
      expect(
        snapshot.repository.totalDirectories,
        repositoryModel.totalDirectories,
      );

      expect(snapshot.imports, hasLength(originalImports.length));

      for (var i = 0; i < originalImports.length; i++) {
        expect(snapshot.imports[i].source, originalImports[i].source);
        expect(snapshot.imports[i].target, originalImports[i].target);
        expect(snapshot.imports[i].type, originalImports[i].type);
      }

      expect(
        snapshot.inventory,
        isNot(same(originalInventory)),
      );
      expect(
        snapshot.inventory.totalFiles,
        originalInventory?.totalFiles,
      );

      expect(snapshot.graph, same(originalGraph));
      expect(snapshot.stats, same(originalStats));

      expect(snapshot.imports, isNot(same(scanner.imports)));
    });
  });
}
