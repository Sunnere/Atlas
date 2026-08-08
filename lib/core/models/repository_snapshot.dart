import '../../import_reference.dart';
import 'repository_model.dart';

/// Immutable snapshot of everything Atlas knows about a repository.
///
/// The snapshot is the contract shared between scanners,
/// analysis services and commands.
///
/// During the migration it contains the RepositoryModel and
/// the import references discovered for that repository.
/// Additional knowledge (graph, metrics, inventory...)
/// will be added in later commits.
class RepositorySnapshot {
  const RepositorySnapshot({
    required this.repository,
    required this.imports,
  });

  final RepositoryModel repository;

  final List<ImportReference> imports;
}
