import 'package:atlas/graph_builder.dart';
import 'package:atlas/graph_edge.dart';
import 'package:atlas/graph_metrics.dart';
import 'package:atlas/graph_node.dart';
import 'package:atlas/graph_query.dart';
import 'package:atlas/import_reference.dart';
import 'package:atlas/import_type.dart';
import 'package:atlas/knowledge_graph.dart';
import 'package:atlas/core/models/repository_inventory.dart';
import 'package:atlas/core/models/repository_item.dart';
import 'package:atlas/relationship_builder.dart';
import 'package:test/test.dart';

void main() {
  group('KnowledgeGraph', () {
    test('adds and retrieves nodes', () {
      final graph = KnowledgeGraph();

      const node = GraphNode(
        id: '/repo/lib/a.dart',
        name: 'a.dart',
        path: '/repo/lib/a.dart',
        type: 'unknown',
      );

      graph.addNode(node);

      expect(graph.nodeCount, 1);
      expect(graph.contains(node.id), isTrue);
      expect(graph.getNode(node.id), same(node));
    });

    test('adds edges', () {
      final graph = KnowledgeGraph();

      const edge = GraphEdge(
        from: '/repo/lib/a.dart',
        to: '/repo/lib/b.dart',
        type: 'import',
      );

      graph.addEdge(edge);

      expect(graph.edgeCount, 1);
      expect(graph.edges.single, same(edge));
    });
  });

  group('RelationshipBuilder', () {
    test('converts imports into graph edges', () {
      const builder = RelationshipBuilder();

      final edges = builder.build([
        const ImportReference(
          source: '/repo/lib/a.dart',
          target: 'package:atlas/b.dart',
          type: ImportType.package,
        ),
      ]);

      expect(edges, hasLength(1));
      expect(edges.single.from, '/repo/lib/a.dart');
      expect(edges.single.to, 'package:atlas/b.dart');
      expect(edges.single.type, 'import');
    });
  });

  group('GraphBuilder', () {
    test('builds graph nodes and relationships from inventory', () {
      final inventory = RepositoryInventory(
        items: [
          RepositoryItem(path: '/repo/lib/a.dart'),
          RepositoryItem(path: '/repo/lib/b.dart'),
        ],
      );

      final graph = const GraphBuilder().build(
        inventory,
        imports: [
          const ImportReference(
            source: '/repo/lib/a.dart',
            target: '/repo/lib/b.dart',
            type: ImportType.local,
          ),
        ],
      );

      expect(graph.nodeCount, 2);
      expect(graph.edgeCount, 1);
      expect(graph.contains('/repo/lib/a.dart'), isTrue);
      expect(graph.contains('/repo/lib/b.dart'), isTrue);
    });
  });

  group('GraphQuery', () {
    test('finds incoming and outgoing import relationships', () {
      final graph = KnowledgeGraph();

      graph.addNode(
        const GraphNode(
          id: '/repo/lib/a.dart',
          name: 'a.dart',
          path: '/repo/lib/a.dart',
          type: 'unknown',
        ),
      );

      graph.addNode(
        const GraphNode(
          id: '/repo/lib/b.dart',
          name: 'b.dart',
          path: '/repo/lib/b.dart',
          type: 'unknown',
        ),
      );

      graph.addEdge(
        const GraphEdge(
          from: '/repo/lib/a.dart',
          to: '/repo/lib/b.dart',
          type: 'import',
        ),
      );

      final query = GraphQuery(graph);

      expect(query.importsOf('/repo/lib/a.dart'), hasLength(1));
      expect(query.importedBy('/repo/lib/b.dart'), hasLength(1));
      expect(query.dependenciesOf('/repo/lib/a.dart'), hasLength(1));
      expect(query.dependentsOf('/repo/lib/b.dart'), hasLength(1));
    });
  });

  group('GraphMetrics', () {
    test('calculates graph dependency metrics', () {
      final graph = KnowledgeGraph();

      for (final id in ['/repo/a.dart', '/repo/b.dart', '/repo/c.dart']) {
        graph.addNode(
          GraphNode(
            id: id,
            name: id.split('/').last,
            path: id,
            type: 'unknown',
          ),
        );
      }

      graph.addEdge(
        const GraphEdge(
          from: '/repo/a.dart',
          to: '/repo/b.dart',
          type: 'import',
        ),
      );

      graph.addEdge(
        const GraphEdge(
          from: '/repo/c.dart',
          to: '/repo/b.dart',
          type: 'import',
        ),
      );

      final query = GraphQuery(graph);
      final metrics = GraphMetrics(
        graph: graph,
        query: query,
      );

      expect(metrics.mostImported().first.value, 2);
      expect(metrics.mostDependencies().first.value, 1);
      expect(metrics.leafNodes(), contains('/repo/b.dart'));
      expect(metrics.rootNodes(), contains('/repo/a.dart'));
      expect(metrics.rootNodes(), contains('/repo/c.dart'));
      expect(metrics.isolatedNodes(), isEmpty);
    });
  });
}
