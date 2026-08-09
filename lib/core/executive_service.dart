import 'package:atlas/core/models/repository_snapshot.dart';
import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/scanner/repository_scanner.dart';

/// Atlas Executive API.
///
/// ExecutiveService is the primary entry point for consumers of Atlas Core.
/// It orchestrates repository scanning and exposes the current repository
/// snapshot without adding business logic to lower-level capabilities.
class ExecutiveService {
  ExecutiveService({
    required RepositoryScanner scanner,
    required this.repositoryRoot,
  }) : _scanner = scanner;

  final RepositoryScanner _scanner;
  final String repositoryRoot;

  RepositorySnapshot? _snapshot;

  RepositorySnapshot? get snapshot => _snapshot;

  get stats => _snapshot?.stats;

  get inventory => _snapshot?.inventory;

  get graph => _snapshot?.graph;

  get repository => _snapshot?.repository;

  get imports => _snapshot?.imports ?? const [];

  Future<void> refresh() async {
    final repository = await _scanner.scan(repositoryRoot);

    _snapshot = const RepositorySnapshotBuilder().build(
      repository,
      imports: _scanner.imports,
      inventory: _scanner.inventory,
      graph: _scanner.graph,
      stats: _scanner.stats,
    );
  }

  bool get hasScan => _snapshot != null;
}
