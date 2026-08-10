import '../../import_reference.dart';
import '../../knowledge_graph.dart';
import 'repository_inventory.dart';
import '../../repository_stats.dart';
import 'repository_model.dart';

/// Snapshot of the knowledge discovered for a repository.
///
/// The snapshot is the shared contract between repository scanning,
/// analysis services and Atlas commands.
///
/// Knowledge is migrated into the snapshot incrementally.
class RepositorySnapshot {
  const RepositorySnapshot({
    required this.repository,
    required this.imports,
    required this.inventory,
    required this.graph,
    required this.stats,
  });

  final RepositoryModel repository;

  final List<ImportReference> imports;

  final RepositoryInventory inventory;

  final KnowledgeGraph graph;

  final RepositoryStats stats;
}
