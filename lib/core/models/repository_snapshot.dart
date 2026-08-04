import 'repository_model.dart';

/// Immutable snapshot of everything Atlas knows about a repository.
///
/// The snapshot is the contract shared between scanners,
/// analysis services and commands.
///
/// During the migration it only contains RepositoryModel.
/// Additional knowledge (imports, graph, metrics, inventory...)
/// will be added in later commits.
class RepositorySnapshot {
  const RepositorySnapshot({
    required this.repository,
  });

  final RepositoryModel repository;
}
