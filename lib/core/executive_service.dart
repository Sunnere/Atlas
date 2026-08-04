import 'package:atlas/knowledge_graph.dart';
import 'package:atlas/repository_inventory.dart';
import 'package:atlas/repository_scanner.dart';
import 'package:atlas/repository_stats.dart';

/// Atlas Executive API.
///
/// ExecutiveService is the primary entry point for consumers of Atlas Core.
/// It orchestrates repository scanning and exposes the current repository state
/// without adding business logic to the lower-level engine.
class ExecutiveService {
  ExecutiveService({
    required RepositoryScanner scanner,
  }) : _scanner = scanner;

  final RepositoryScanner _scanner;

  RepositoryStats? _stats;

  RepositoryStats? get stats => _stats;

  RepositoryInventory? get inventory => _scanner.inventory;

  KnowledgeGraph? get graph => _scanner.graph;

  Future<void> refresh() async {
    _stats = await _scanner.scan();
  }

  bool get hasScan => _stats != null;
}
