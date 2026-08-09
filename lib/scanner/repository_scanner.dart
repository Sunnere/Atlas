import 'dart:io';

import '../core/models/file_info.dart';
import '../core/models/repository_model.dart';
import '../graph_builder.dart';
import '../import_reference.dart';
import '../import_scanner.dart';
import '../knowledge_graph.dart';
import '../repository_inventory.dart';
import '../repository_item.dart';
import 'language_detector.dart';

class RepositoryScanner {
  RepositoryScanner({
    this.importScanner = const ImportScanner(),
  });

  final ImportScanner importScanner;

  final List<ImportReference> _imports = [];
  RepositoryInventory? _inventory;
  KnowledgeGraph? _graph;

  List<ImportReference> get imports => List.unmodifiable(_imports);

  RepositoryInventory? get inventory => _inventory;

  KnowledgeGraph? get graph => _graph;

  Future<RepositoryModel> scan(String rootPath) async {
    final stopwatch = Stopwatch()..start();

    final files = <FileInfo>[];
    var directories = 0;

    _imports.clear();

    final inventory = RepositoryInventory();

    await for (final entity
        in Directory(rootPath).list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        directories++;
        continue;
      }

      if (entity is! File) continue;

      final extension = _extension(entity.path);

      files.add(
        FileInfo(
          path: entity.path,
          extension: extension,
          size: await entity.length(),
          language: LanguageDetector.detect(extension),
        ),
      );

      inventory.add(
        RepositoryItem(
          path: entity.path,
        ),
      );

      if (extension == '.dart') {
        _imports.addAll(
          importScanner.scan(entity),
        );
      }
    }

    final graph = const GraphBuilder().build(
      inventory,
      imports: _imports,
    );

    _inventory = inventory;
    _graph = graph;

    stopwatch.stop();

    return RepositoryModel(
      rootPath: rootPath,
      files: files,
      totalDirectories: directories,
      scanDuration: stopwatch.elapsed,
    );
  }

  String _extension(String path) {
    final index = path.lastIndexOf('.');

    if (index == -1) {
      return '';
    }

    return path.substring(index);
  }
}
