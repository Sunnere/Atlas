import '../../import_reference.dart';
import '../../repository_inventory.dart';
import 'repository_model.dart';

/// Immutable snapshot of everything Atlas knows about a repository.
///
/// The snapshot is the contract shared between scanners,
/// analysis services and commands.
///
/// During the migration it contains the RepositoryModel,
/// import references and repository inventory.
/// Additional knowledge (graph, metrics...)
/// will be added in later commits.
class RepositorySnapshot {
  const RepositorySnapshot({
    required this.repository,
    required this.imports,
    required this.inventory,
  });

  final RepositoryModel repository;

  final List<ImportReference> imports;

  final RepositoryInventory inventory;
}
