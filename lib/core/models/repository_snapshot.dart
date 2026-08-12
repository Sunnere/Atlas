import '../../import_reference.dart';
import '../graph/knowledge_graph.dart';
import 'repository_inventory_snapshot.dart';
import 'repository_model.dart';
import 'repository_stats.dart';

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
  final RepositoryInventorySnapshot inventory;
  final KnowledgeGraph graph;
  final RepositoryStats stats;
}
