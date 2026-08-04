import 'models/repository_model.dart';
import 'models/repository_snapshot.dart';

/// Builds immutable RepositorySnapshot instances.
///
/// The builder currently wraps RepositoryModel only.
/// Additional engineering knowledge (imports, graph,
/// inventory, metrics...) will be added in future commits.
class RepositorySnapshotBuilder {
  const RepositorySnapshotBuilder();

  RepositorySnapshot build(
    RepositoryModel repository,
  ) {
    return RepositorySnapshot(
      repository: repository,
    );
  }
}
