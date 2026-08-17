import 'package:atlas/core/graph/graph_edge.dart';
import 'package:atlas/core/graph/graph_node.dart';
import 'package:atlas/core/graph/knowledge_graph.dart';
import 'package:atlas/core/models/file_info.dart';
import 'package:atlas/core/models/repository_inventory_snapshot.dart';
import 'package:atlas/core/models/repository_item.dart';
import 'package:atlas/core/models/repository_model.dart';
import 'package:atlas/core/models/repository_snapshot.dart';
import 'package:atlas/core/models/repository_stats.dart';
import 'package:atlas/core/models/snapshot_provenance.dart';
import 'package:atlas/core/snapshot/canonical_snapshot.dart';
import 'package:atlas/import_reference.dart';
import 'package:atlas/import_type.dart';
import 'package:test/test.dart';

RepositorySnapshot buildSnapshot({
  required List<FileInfo> files,
  required List<RepositoryItem> inventory,
  required List<ImportReference> imports,
  required KnowledgeGraph graph,
  required Duration scanDuration,
  DateTime? capturedAt,
}) {
  final repository = RepositoryModel(
    rootPath: '/different/root',
    files: files,
    totalDirectories: 3,
    scanDuration: scanDuration,
  );

  return RepositorySnapshot(
    repository: repository,
    imports: imports,
    inventory: RepositoryInventorySnapshot(
      items: inventory,
    ),
    graph: graph,
    stats: const RepositoryStats(
      directories: 3,
      dartFiles: 1,
      testFiles: 0,
      pubspecFiles: 0,
    ),
    provenance: SnapshotProvenance(
      capturedAt: capturedAt ?? DateTime.utc(2026, 8, 13),
      sourcePath: '/different/root',
      scannerVersion: '1.0.0',
      gitCommit: 'abc123',
    ),
  );
}

void main() {
  test('canonical JSON is deterministic for different discovery order', () {
    final files = const [
      FileInfo(
        path: 'lib/b.dart',
        extension: '.dart',
        size: 20,
        language: 'dart',
      ),
      FileInfo(
        path: 'lib/a.dart',
        extension: '.dart',
        size: 10,
        language: 'dart',
      ),
    ];

    final inventory = [
      RepositoryItem(path: 'lib/services/example.dart'),
      RepositoryItem(path: 'lib/models/example.dart'),
    ];

    final imports = const [
      ImportReference(
        source: 'lib/b.dart',
        target: 'package:test/test.dart',
        type: ImportType.package,
      ),
      ImportReference(
        source: 'lib/a.dart',
        target: 'lib/b.dart',
        type: ImportType.local,
      ),
    ];

    final graphA = KnowledgeGraph(
      nodes: const [
        GraphNode(
          id: 'b',
          name: 'B',
          path: 'lib/b.dart',
          type: 'service',
        ),
        GraphNode(
          id: 'a',
          name: 'A',
          path: 'lib/a.dart',
          type: 'model',
        ),
      ],
      edges: const [
        GraphEdge(
          from: 'b',
          to: 'a',
          type: 'uses',
        ),
      ],
    );

    final graphB = KnowledgeGraph(
      nodes: const [
        GraphNode(
          id: 'a',
          name: 'A',
          path: 'lib/a.dart',
          type: 'model',
        ),
        GraphNode(
          id: 'b',
          name: 'B',
          path: 'lib/b.dart',
          type: 'service',
        ),
      ],
      edges: const [
        GraphEdge(
          from: 'b',
          to: 'a',
          type: 'uses',
        ),
      ],
    );

    final first = buildSnapshot(
      files: files,
      inventory: inventory,
      imports: imports,
      graph: graphA,
      scanDuration: const Duration(milliseconds: 10),
    );

    final second = buildSnapshot(
      files: files.reversed.toList(),
      inventory: inventory.reversed.toList(),
      imports: imports.reversed.toList(),
      graph: graphB,
      scanDuration: const Duration(seconds: 20),
    );

    expect(
      CanonicalSnapshot.from(first).canonicalJson,
      CanonicalSnapshot.from(second).canonicalJson,
    );
  });

  test('scan duration does not affect canonical identity', () {
    const files = [
      FileInfo(
        path: 'lib/example.dart',
        extension: '.dart',
        size: 10,
        language: 'dart',
      ),
    ];

    final first = buildSnapshot(
      files: files,
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: const Duration(milliseconds: 1),
    );

    final second = buildSnapshot(
      files: files,
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: const Duration(seconds: 5),
    );

    expect(
      CanonicalSnapshot.from(first).canonicalJson,
      CanonicalSnapshot.from(second).canonicalJson,
    );
  });

  test('provenance does not affect canonical identity', () {
    const files = [
      FileInfo(
        path: 'lib/example.dart',
        extension: '.dart',
        size: 10,
        language: 'dart',
      ),
    ];

    final first = buildSnapshot(
      files: files,
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: Duration.zero,
      capturedAt: DateTime.utc(2026, 8, 13),
    );

    final second = buildSnapshot(
      files: files,
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: Duration.zero,
      capturedAt: DateTime.utc(2030, 1, 1),
    );

    expect(
      CanonicalSnapshot.from(first).canonicalJson,
      CanonicalSnapshot.from(second).canonicalJson,
    );
  });

  test('content changes canonical identity', () {
    final first = buildSnapshot(
      files: const [
        FileInfo(
          path: 'lib/example.dart',
          extension: '.dart',
          size: 10,
          language: 'dart',
        ),
      ],
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: Duration.zero,
    );

    final second = buildSnapshot(
      files: const [
        FileInfo(
          path: 'lib/example.dart',
          extension: '.dart',
          size: 20,
          language: 'dart',
        ),
      ],
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: Duration.zero,
    );

    expect(
      CanonicalSnapshot.from(first).canonicalJson,
      isNot(
        CanonicalSnapshot.from(second).canonicalJson,
      ),
    );
  });

  test('root path does not affect canonical identity', () {
    final first = buildSnapshot(
      files: const [
        FileInfo(
          path: 'lib/example.dart',
          extension: '.dart',
          size: 10,
          language: 'dart',
        ),
      ],
      inventory: [
        RepositoryItem(path: 'lib/models/example.dart'),
      ],
      imports: const [],
      graph: KnowledgeGraph(),
      scanDuration: Duration.zero,
    );

    final second = RepositorySnapshot(
      repository: RepositoryModel(
        rootPath: '/another/root',
        files: const [
          FileInfo(
            path: 'lib/example.dart',
            extension: '.dart',
            size: 10,
            language: 'dart',
          ),
        ],
        totalDirectories: 3,
        scanDuration: const Duration(seconds: 999),
      ),
      imports: const [],
      inventory: RepositoryInventorySnapshot(
        items: [
          RepositoryItem(path: 'lib/models/example.dart'),
        ],
      ),
      graph: KnowledgeGraph(),
      stats: const RepositoryStats(
        directories: 3,
        dartFiles: 1,
        testFiles: 0,
        pubspecFiles: 0,
      ),
      provenance: SnapshotProvenance(
        capturedAt: DateTime.utc(2040),
        sourcePath: '/another/root',
        scannerVersion: '99.0.0',
        gitCommit: 'different',
      ),
    );

    expect(
      CanonicalSnapshot.from(first).canonicalJson,
      CanonicalSnapshot.from(second).canonicalJson,
    );
  });
}
