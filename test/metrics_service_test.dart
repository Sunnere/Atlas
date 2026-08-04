import 'package:atlas/core/metrics_service.dart';
import 'package:atlas/repository_stats.dart';
import 'package:test/test.dart';

void main() {
  group('MetricsService', () {
    test('buildRepositoryMetrics returns repository values', () {
      const stats = RepositoryStats(
        directories: 10,
        dartFiles: 25,
        testFiles: 5,
        pubspecFiles: 1,
      );

      final metrics = const MetricsService().buildRepositoryMetrics(stats);

      expect(metrics['directories'], 10);
      expect(metrics['dartFiles'], 25);
      expect(metrics['testFiles'], 5);
      expect(metrics['pubspecFiles'], 1);
    });

    test('healthScore is 100 for healthy repository', () {
      const stats = RepositoryStats(
        directories: 10,
        dartFiles: 25,
        testFiles: 5,
        pubspecFiles: 1,
      );

      expect(const MetricsService().healthScore(stats), 100);
    });

    test('healthScore decreases when tests are missing', () {
      const stats = RepositoryStats(
        directories: 10,
        dartFiles: 25,
        testFiles: 0,
        pubspecFiles: 1,
      );

      expect(const MetricsService().healthScore(stats), 80);
    });
  });
}
