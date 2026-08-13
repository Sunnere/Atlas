import 'dart:io';

import 'package:atlas/core/models/snapshot_provenance.dart';
import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/scanner/repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('RepositorySnapshot provenance', () {
    late Directory repository;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'atlas_snapshot_provenance_test_',
      );

      Directory('${repository.path}/lib').createSync(recursive: true);

      File('${repository.path}/lib/example.dart').writeAsStringSync(
        'class Example {}',
      );
    });

    tearDown(() {
      if (repository.existsSync()) {
        repository.deleteSync(recursive: true);
      }
    });

    test('builder creates provenance automatically', () async {
      final scanner = RepositoryScanner();
      final repositoryModel = await scanner.scan(repository.path);

      final before = DateTime.now().toUtc();

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        imports: scanner.imports,
        inventory: scanner.inventory,
        graph: scanner.graph,
        stats: scanner.stats,
      );

      final after = DateTime.now().toUtc();

      expect(
        snapshot.provenance.capturedAt.isAfter(
          before.subtract(const Duration(seconds: 1)),
        ),
        isTrue,
      );

      expect(
        snapshot.provenance.capturedAt.isBefore(
          after.add(const Duration(seconds: 1)),
        ),
        isTrue,
      );

      expect(
        snapshot.provenance.sourcePath,
        repository.path,
      );

      expect(
        snapshot.provenance.scannerVersion,
        SnapshotProvenance.currentScannerVersion,
      );

      expect(snapshot.provenance.gitCommit, isNull);
    });

    test('builder preserves explicitly supplied provenance', () async {
      final scanner = RepositoryScanner();
      final repositoryModel = await scanner.scan(repository.path);

      final provenance = SnapshotProvenance(
        capturedAt: DateTime.utc(2026, 8, 13, 15, 30),
        sourcePath: '/historical/atlas',
        scannerVersion: '2.0.0',
        gitCommit: 'abc1234',
      );

      final snapshot = const RepositorySnapshotBuilder().build(
        repositoryModel,
        inventory: scanner.inventory,
        imports: scanner.imports,
        graph: scanner.graph,
        stats: scanner.stats,
        provenance: provenance,
      );

      expect(snapshot.provenance.capturedAt, provenance.capturedAt);
      expect(snapshot.provenance.sourcePath, provenance.sourcePath);
      expect(snapshot.provenance.scannerVersion, provenance.scannerVersion);
      expect(snapshot.provenance.gitCommit, provenance.gitCommit);
    });
  });
}
