import '../import_reference.dart';
import 'graph/knowledge_graph.dart';
import 'models/repository_inventory.dart';
import 'models/repository_inventory_snapshot.dart';
import 'models/repository_stats.dart';
import 'models/repository_model.dart';
import 'models/repository_snapshot.dart';

/// Builds immutable RepositorySnapshot instances.
///
/// The builder combines the repository model with the engineering
/// knowledge discovered during repository scanning.
class RepositorySnapshotBuilder {
  const RepositorySnapshotBuilder();

  RepositorySnapshot build(
    RepositoryModel repository, {
    List<ImportReference> imports = const [],
    RepositoryInventory? inventory,
    KnowledgeGraph? graph,
    RepositoryStats? stats,
  }) {
    final inventorySnapshot = RepositoryInventorySnapshot(
      items: inventory?.items ?? const [],
    );

    return RepositorySnapshot(
      repository: repository,
      imports: List.unmodifiable(imports),
      inventory: inventorySnapshot,
      graph: graph ?? KnowledgeGraph(),
      stats: stats ??
          RepositoryStats(
            directories: repository.totalDirectories,
            dartFiles: repository.files
                .where((file) => file.extension == '.dart')
                .length,
            testFiles: inventory?.tests.length ?? 0,
            pubspecFiles: inventory?.configs
                    .where((item) => item.name == 'pubspec.yaml')
                    .length ??
                0,
          ),
    );
  }
}
