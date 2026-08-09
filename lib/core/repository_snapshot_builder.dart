import '../import_reference.dart';
import '../knowledge_graph.dart';
import '../repository_inventory.dart';
import 'models/repository_model.dart';
import 'models/repository_snapshot.dart';

/// Builds RepositorySnapshot instances.
///
/// The builder combines the repository model with the engineering
/// knowledge discovered during repository scanning.
///
/// Additional knowledge will be added in later migration steps.
class RepositorySnapshotBuilder {
  const RepositorySnapshotBuilder();

  RepositorySnapshot build(
    RepositoryModel repository, {
    List<ImportReference> imports = const [],
    RepositoryInventory? inventory,
    KnowledgeGraph? graph,
  }) {
    return RepositorySnapshot(
      repository: repository,
      imports: List.unmodifiable(imports),
      inventory: inventory ?? RepositoryInventory(),
      graph: graph ?? KnowledgeGraph(),
    );
  }
}
