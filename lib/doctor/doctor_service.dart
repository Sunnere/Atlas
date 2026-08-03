import '../core/models/repository_model.dart';
import '../import_reference.dart';
import '../import_summary.dart';
import 'doctor_report.dart';

class DoctorService {
  const DoctorService();

  DoctorReport analyze({
    required RepositoryModel repository,
    required List<ImportReference> imports,
  }) {
    final summary = ImportSummary.fromImports(imports);

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
    );
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
