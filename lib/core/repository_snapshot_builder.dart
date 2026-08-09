import '../import_reference.dart';
import '../repository_inventory.dart';
import 'models/repository_model.dart';
import 'models/repository_snapshot.dart';

/// Builds immutable RepositorySnapshot instances.
///
/// The builder combines the repository model with the
/// engineering knowledge discovered during repository scanning.
/// Additional knowledge (graph, metrics...) will be added
/// in future commits.
class RepositorySnapshotBuilder {
  const RepositorySnapshotBuilder();

  RepositorySnapshot build(
    RepositoryModel repository, {
    List<ImportReference> imports = const [],
    RepositoryInventory? inventory,
  }) {
    return RepositorySnapshot(
      repository: repository,
      imports: List.unmodifiable(imports),
      inventory: inventory ?? RepositoryInventory(),
    );
  }
}
