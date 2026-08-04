import 'package:atlas/repository_stats.dart';

class MetricsService {
  const MetricsService();

  Map<String, int> buildRepositoryMetrics(
    RepositoryStats stats,
  ) {
    return {
      'directories': stats.directories,
      'dartFiles': stats.dartFiles,
      'testFiles': stats.testFiles,
      'pubspecFiles': stats.pubspecFiles,
    };
  }

  int healthScore(
    RepositoryStats stats,
  ) {
    var score = 100;

    if (stats.testFiles == 0) {
      score -= 20;
    }

    if (stats.pubspecFiles == 0) {
      score -= 10;
    }

    if (score < 0) {
      score = 0;
    }

    return score;
  }
}
