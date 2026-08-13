import 'package:atlas/core/models/snapshot_provenance.dart';
import 'package:test/test.dart';

void main() {
  group('SnapshotProvenance', () {
    test('stores complete provenance metadata', () {
      final capturedAt = DateTime.utc(2026, 8, 13, 12, 0);

      final provenance = SnapshotProvenance(
        capturedAt: capturedAt,
        sourcePath: '/tmp/atlas',
        scannerVersion: '1.0.0',
        gitCommit: '7343e11',
      );

      expect(provenance.capturedAt, capturedAt);
      expect(provenance.sourcePath, '/tmp/atlas');
      expect(provenance.scannerVersion, '1.0.0');
      expect(provenance.gitCommit, '7343e11');
    });

    test('allows snapshots without git metadata', () {
      final provenance = SnapshotProvenance(
        capturedAt: DateTime.utc(2026, 8, 13, 12, 0),
        sourcePath: '/tmp/atlas',
        scannerVersion: '1.0.0',
      );

      expect(provenance.gitCommit, isNull);
    });
  });
}
