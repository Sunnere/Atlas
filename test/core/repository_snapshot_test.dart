import 'package:atlas/core/models/repository_model.dart';
import 'package:atlas/core/repository_snapshot_builder.dart';
import 'package:atlas/repository_inventory.dart';
import 'package:atlas/repository_item.dart';
import 'package:test/test.dart';

void main() {
  group('RepositorySnapshot inventory', () {
    test('preserves repository inventory through the snapshot builder', () {
      final inventory = RepositoryInventory(
        items: [
          RepositoryItem(path: '/repo/lib/models/example.dart'),
          RepositoryItem(path: '/repo/test/example_test.dart'),
        ],
      );

      const repository = RepositoryModel(
        rootPath: '/repo',
        files: [],
        totalDirectories: 0,
        scanDuration: Duration.zero,
      );

      final snapshot = const RepositorySnapshotBuilder().build(
        repository,
        inventory: inventory,
      );

      expect(snapshot.inventory.totalFiles, 2);
      expect(snapshot.inventory.models, hasLength(1));
      expect(snapshot.inventory.tests, hasLength(1));
      expect(snapshot.inventory.items, same(inventory.items));
    });
  });
}
