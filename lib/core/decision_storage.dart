import 'dart:convert';

import 'package:atlas/core/executive_decision.dart';
import 'package:atlas/core/storage_service.dart';

class DecisionStorage {
  DecisionStorage({
    required StorageService storage,
    this.path = '.atlas/executive_memory.json',
  }) : _storage = storage;

  final StorageService _storage;
  final String path;

  Future<void> save(
    Iterable<ExecutiveDecision> decisions,
  ) async {
    final json = decisions
        .map(
          (d) => {
            'id': d.id,
            'title': d.title,
            'status': d.status,
            'context': d.context,
            'decision': d.decision,
            'reasoning': d.reasoning,
            'impact': d.impact,
            'createdAt': d.createdAt.toIso8601String(),
            'tags': d.tags,
            'projects': d.projects,
          },
        )
        .toList();

    await _storage.writeText(
      path: path,
      content: const JsonEncoder.withIndent('  ').convert(json),
    );
  }

  Future<List<Map<String, dynamic>>> load() async {
    final text = await _storage.readText(path: path);

    if (text == null || text.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(text) as List<dynamic>;

    return decoded.cast<Map<String, dynamic>>();
  }
}
