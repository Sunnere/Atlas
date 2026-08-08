import '../import_reference.dart';
import 'models/repository_model.dart';
import 'models/repository_snapshot.dart';

/// Builds immutable RepositorySnapshot instances.
///
/// The builder currently combines the repository model with
/// the import references discovered for that repository.
/// Additional engineering knowledge (graph, metrics,
/// inventory...) will be added in future commits.
class RepositorySnapshotBuilder {
  const RepositorySnapshotBuilder();

  RepositorySnapshot build(
    RepositoryModel repository, {
    List<ImportReference> imports = const [],
  }) {
    return RepositorySnapshot(
      repository: repository,
      imports: List.unmodifiable(imports),
    );
  }
}
