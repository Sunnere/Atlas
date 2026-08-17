import 'package:atlas/core/graph/knowledge_graph.dart';
import 'package:atlas/core/models/file_info.dart';
import 'package:atlas/core/models/repository_inventory_snapshot.dart';
import 'package:atlas/core/models/repository_model.dart';
import 'package:atlas/core/models/repository_snapshot.dart';
import 'package:atlas/core/models/repository_stats.dart';
import 'package:atlas/core/models/snapshot_provenance.dart';
import 'package:atlas/core/snapshot/canonical_snapshot.dart';
import 'package:atlas/core/snapshot/snapshot_identity.dart';
import 'package:test/test.dart';

RepositorySnapshot buildSnapshot({
  required int fileSize,
}) {
  return RepositorySnapshot(
    repository: RepositoryModel(
      rootPath: '/repo',
      files: [
        FileInfo(
          path: 'lib/example.dart',
          extension: '.dart',
          size: fileSize,
          language: 'dart',
        ),
      ],
      totalDirectories: 1,
      scanDuration: const Duration(milliseconds: 100),
    ),
    imports: const [],
    inventory: RepositoryInventorySnapshot(
      items: const [],
    ),
    graph: KnowledgeGraph(),
    stats: const RepositoryStats(
      directories: 1,
      dartFiles: 1,
      testFiles: 0,
      pubspecFiles: 0,
    ),
    provenance: SnapshotProvenance(
      capturedAt: DateTime.utc(2026, 8, 16),
      sourcePath: '/repo',
      scannerVersion: '1.0.0',
    ),
  );
}

void main() {
  test('uses sha256', () {
    final canonical = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 10),
    );

    final identity = SnapshotIdentity.from(canonical);

    expect(identity.algorithm, 'sha256');
  });

  test('produces a 64-character hexadecimal digest', () {
    final canonical = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 10),
    );

    final identity = SnapshotIdentity.from(canonical);

    expect(identity.value, hasLength(64));
    expect(
      RegExp(r'^[0-9a-f]{64}$').hasMatch(identity.value),
      isTrue,
    );
  });

  test('same canonical content produces the same identity', () {
    final first = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 10),
    );

    final second = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 10),
    );

    expect(
      SnapshotIdentity.from(first).value,
      SnapshotIdentity.from(second).value,
    );
  });

  test('changed content produces a different identity', () {
    final first = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 10),
    );

    final second = CanonicalSnapshot.from(
      buildSnapshot(fileSize: 20),
    );

    expect(
      SnapshotIdentity.from(first).value,
      isNot(SnapshotIdentity.from(second).value),
    );
  });

  test('provenance does not affect identity', () {
    final first = RepositorySnapshot(
      repository: RepositoryModel(
        rootPath: '/repo-a',
        files: const [
          FileInfo(
            path: 'lib/example.dart',
            extension: '.dart',
            size: 10,
            language: 'dart',
          ),
        ],
        totalDirectories: 1,
        scanDuration: Duration.zero,
      ),
      imports: const [],
      inventory: RepositoryInventorySnapshot(
        items: const [],
      ),
      graph: KnowledgeGraph(),
      stats: const RepositoryStats(
        directories: 1,
        dartFiles: 1,
        testFiles: 0,
        pubspecFiles: 0,
      ),
      provenance: SnapshotProvenance(
        capturedAt: DateTime.utc(2026, 8, 16),
        sourcePath: '/repo-a',
        scannerVersion: '1.0.0',
        gitCommit: 'commit-a',
      ),
    );

    final second = RepositorySnapshot(
      repository: RepositoryModel(
        rootPath: '/repo-b',
        files: const [
          FileInfo(
            path: 'lib/example.dart',
            extension: '.dart',
            size: 10,
            language: 'dart',
          ),
        ],
        totalDirectories: 1,
        scanDuration: Duration(seconds: 10),
      ),
      imports: const [],
      inventory: RepositoryInventorySnapshot(
        items: const [],
      ),
      graph: KnowledgeGraph(),
      stats: const RepositoryStats(
        directories: 1,
        dartFiles: 1,
        testFiles: 0,
        pubspecFiles: 0,
      ),
      provenance: SnapshotProvenance(
        capturedAt: DateTime.utc(2030, 1, 1),
        sourcePath: '/repo-b',
        scannerVersion: '9.0.0',
        gitCommit: 'commit-b',
      ),
    );

    final firstIdentity = SnapshotIdentity.from(
      CanonicalSnapshot.from(first),
    );

    final secondIdentity = SnapshotIdentity.from(
      CanonicalSnapshot.from(second),
    );

    expect(firstIdentity.value, secondIdentity.value);
  });
}
