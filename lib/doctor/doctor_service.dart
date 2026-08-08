import '../core/models/repository_model.dart';
import '../import_reference.dart';
import '../import_summary.dart';
import 'doctor_observation.dart';
import 'doctor_report.dart';

class DoctorService {
  const DoctorService();

  DoctorReport analyze({
    required RepositoryModel repository,
    required List<ImportReference> imports,
  }) {
    final summary = ImportSummary.fromImports(imports);

    return _buildReport(
      repository: repository,
      summary: summary,
    );
  }

  DoctorReport _buildReport({
    required RepositoryModel repository,
    required ImportSummary summary,
  }) {
    final dartFiles = repository.files
        .where((file) => file.extension == '.dart')
        .length;

    return DoctorReport(
      repositoryPath: repository.rootPath,
      totalFiles: repository.totalFiles,
      dartFiles: dartFiles,
      localImports: summary.local,
      packageImports: summary.package,
      flutterImports: summary.flutter,
      dartSdkImports: summary.dartSdk,
      healthScore: _calculateHealthScore(repository, summary),
      observations: _buildObservations(
        repository: repository,
        dartFiles: dartFiles,
        summary: summary,
      ),
    );
  }

  List<DoctorObservation> _buildObservations({
    required RepositoryModel repository,
    required int dartFiles,
    required ImportSummary summary,
  }) {
    final observations = <DoctorObservation>[];

    if (repository.totalFiles == 0) {
      observations.add(
        const DoctorObservation(
          title: 'Repository is empty',
          evidence: 'The repository contains 0 files.',
          recommendation:
              'Add source files before running engineering analysis.',
        ),
      );
    } else {
      observations.add(
        DoctorObservation(
          title: 'Repository analyzed successfully',
          evidence:
              '${repository.totalFiles} files, $dartFiles Dart files, '
              '${repository.totalDirectories} directories.',
          recommendation:
              'Repository baseline is available for further analysis.',
        ),
      );
    }

    if (summary.total == 0) {
      observations.add(
        const DoctorObservation(
          title: 'No imports detected',
          evidence: 'The repository contains 0 detected import references.',
          recommendation:
              'Verify that source files and import statements are being scanned.',
        ),
      );
    } else {
      observations.add(
        DoctorObservation(
          title: 'Import structure detected',
          evidence:
              '${summary.total} imports: '
              '${summary.local} local, '
              '${summary.package} package, '
              '${summary.flutter} Flutter, '
              '${summary.dartSdk} Dart SDK.',
          recommendation:
              'Import evidence is ready for dependency and architecture analysis.',
        ),
      );
    }

    return List.unmodifiable(observations);
  }

  int _calculateHealthScore(
    RepositoryModel repository,
    ImportSummary summary,
  ) {
    var score = 100;

    if (repository.totalFiles == 0) {
      score -= 50;
    }

    if (summary.total == 0) {
      score -= 25;
    }

    return score.clamp(0, 100);
  }
}
