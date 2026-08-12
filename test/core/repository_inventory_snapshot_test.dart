import 'package:atlas/core/models/repository_inventory.dart';
import 'package:atlas/core/models/repository_inventory_snapshot.dart';
import 'package:atlas/core/models/repository_item.dart';
import 'package:test/test.dart';

void main() {
  group('RepositoryInventorySnapshot', () {
    test('copies inventory items into an immutable collection', () {
      final inventory = RepositoryInventory(
        items: [
          RepositoryItem(
            path: 'lib/models/example.dart',
          ),
          RepositoryItem(
            path: 'test/example_test.dart',
          ),
        ],
      );

      final snapshot = RepositoryInventorySnapshot(
        items: inventory.items,
      );

      inventory.add(
        RepositoryItem(
          path: 'lib/models/later.dart',
        ),
      );

      expect(snapshot.totalFiles, 2);
      expect(inventory.totalFiles, 3);
    });

    test('does not allow mutation of snapshot items', () {
      final inventory = RepositoryInventory(
        items: [
          RepositoryItem(
            path: 'lib/models/example.dart',
          ),
        ],
      );

      final snapshot = RepositoryInventorySnapshot(
        items: inventory.items,
      );

      expect(
        () => snapshot.items.clear(),
        throwsUnsupportedError,
      );
    });

    test('preserves category queries', () {
      final snapshot = RepositoryInventorySnapshot(
        items: [
          RepositoryItem(
            path: 'lib/models/example.dart',
          ),
          RepositoryItem(
            path: 'lib/services/example_service.dart',
          ),
          RepositoryItem(
            path: 'test/example_test.dart',
          ),
          RepositoryItem(
            path: 'pubspec.yaml',
          ),
        ],
      );

      expect(snapshot.models, hasLength(1));
      expect(snapshot.services, hasLength(1));
      expect(snapshot.tests, hasLength(1));
      expect(snapshot.configs, hasLength(1));
    });
  });
}
