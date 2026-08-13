import '../graph/knowledge_graph.dart';
import '../../import_reference.dart';
import 'repository_inventory_snapshot.dart';
import 'repository_model.dart';
import 'repository_stats.dart';
import 'snapshot_provenance.dart';

class RepositorySnapshot {
  const RepositorySnapshot({
    required this.repository,
    required this.imports,
    required this.inventory,
    required this.graph,
    required this.stats,
    required this.provenance,
  });

  final RepositoryModel repository;
  final List<ImportReference> imports;
  final RepositoryInventorySnapshot inventory;
  final KnowledgeGraph graph;
  final RepositoryStats stats;
  final SnapshotProvenance provenance;
}
