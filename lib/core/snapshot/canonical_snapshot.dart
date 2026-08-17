import 'dart:convert';

import '../models/repository_snapshot.dart';

class CanonicalSnapshot {
  CanonicalSnapshot._(this._value);

  factory CanonicalSnapshot.from(RepositorySnapshot snapshot) {
    final files = snapshot.repository.files
        .map(
          (file) => <String, Object?>{
            'path': file.path,
            'extension': file.extension,
            'size': file.size,
            'language': file.language,
          },
        )
        .toList()
      ..sort(
        (a, b) => (a['path']! as String).compareTo(
          b['path']! as String,
        ),
      );

    final inventory = snapshot.inventory.items
        .map(
          (item) => <String, Object?>{
            'path': item.path,
            'extension': item.extension,
            'category': item.category,
          },
        )
        .toList()
      ..sort(
        (a, b) => (a['path']! as String).compareTo(
          b['path']! as String,
        ),
      );

    final imports = snapshot.imports
        .map(
          (reference) => <String, Object?>{
            'source': reference.source,
            'target': reference.target,
            'type': reference.type.name,
          },
        )
        .toList()
      ..sort(
        (a, b) {
          final source = (a['source']! as String).compareTo(
            b['source']! as String,
          );

          if (source != 0) {
            return source;
          }

          final target = (a['target']! as String).compareTo(
            b['target']! as String,
          );

          if (target != 0) {
            return target;
          }

          return (a['type']! as String).compareTo(
            b['type']! as String,
          );
        },
      );

    final nodes = snapshot.graph.nodes
        .map(
          (node) => <String, Object?>{
            'id': node.id,
            'name': node.name,
            'path': node.path,
            'type': node.type,
          },
        )
        .toList()
      ..sort(
        (a, b) => (a['id']! as String).compareTo(
          b['id']! as String,
        ),
      );

    final edges = snapshot.graph.edges
        .map(
          (edge) => <String, Object?>{
            'from': edge.from,
            'to': edge.to,
            'type': edge.type,
          },
        )
        .toList()
      ..sort(
        (a, b) {
          final from = (a['from']! as String).compareTo(
            b['from']! as String,
          );

          if (from != 0) {
            return from;
          }

          final to = (a['to']! as String).compareTo(
            b['to']! as String,
          );

          if (to != 0) {
            return to;
          }

          return (a['type']! as String).compareTo(
            b['type']! as String,
          );
        },
      );

    return CanonicalSnapshot._(
      <String, Object?>{
        'totalDirectories': snapshot.repository.totalDirectories,
        'files': files,
        'inventory': inventory,
        'imports': imports,
        'graph': <String, Object?>{
          'nodes': nodes,
          'edges': edges,
        },
      },
    );
  }

  final Map<String, Object?> _value;

  String get canonicalJson => jsonEncode(_value);
}
