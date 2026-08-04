import 'dart:io';

import 'package:atlas/core/storage_service.dart';
import 'package:test/test.dart';

void main() {
  group('StorageService', () {
    const service = StorageService();

    final path = 'test/tmp/storage_test.txt';

    tearDown(() async {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    });

    test('writes and reads text', () async {
      await service.writeText(
        path: path,
        content: 'Atlas',
      );

      final value = await service.readText(
        path: path,
      );

      expect(value, equals('Atlas'));
    });

    test('returns null for missing file', () async {
      final value = await service.readText(
        path: 'test/tmp/missing.txt',
      );

      expect(value, isNull);
    });
  });
}
