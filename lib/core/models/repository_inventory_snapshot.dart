import 'package:atlas/core/models/repository_item.dart';

class RepositoryInventorySnapshot {
  RepositoryInventorySnapshot({
    required List<RepositoryItem> items,
  }) : items = List.unmodifiable(items);

  final List<RepositoryItem> items;

  int get totalFiles => items.length;

  Iterable<RepositoryItem> whereCategory(String category) {
    return items.where((item) => item.category == category);
  }

  List<RepositoryItem> get pages =>
      whereCategory('page').toList(growable: false);

  List<RepositoryItem> get widgets =>
      whereCategory('widget').toList(growable: false);

  List<RepositoryItem> get services =>
      whereCategory('service').toList(growable: false);

  List<RepositoryItem> get repositories =>
      whereCategory('repository').toList(growable: false);

  List<RepositoryItem> get models =>
      whereCategory('model').toList(growable: false);

  List<RepositoryItem> get tests =>
      whereCategory('test').toList(growable: false);

  List<RepositoryItem> get configs =>
      whereCategory('config').toList(growable: false);

  List<RepositoryItem> get scripts =>
      whereCategory('script').toList(growable: false);

  List<RepositoryItem> get unknown =>
      whereCategory('unknown').toList(growable: false);
}
