import 'dart:io';

class StorageService {
  const StorageService();

  Future<void> writeText({
    required String path,
    required String content,
  }) async {
    final file = File(path);

    await file.parent.create(recursive: true);

    await file.writeAsString(content);
  }

  Future<String?> readText({
    required String path,
  }) async {
    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    return file.readAsString();
  }

  Future<bool> exists({
    required String path,
  }) {
    return File(path).exists();
  }
}
