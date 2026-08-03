import '../core/models/repository_model.dart';
import '../import_reference.dart';
import 'doctor_report.dart';
import 'doctor_service.dart';

class DoctorCommand {
  const DoctorCommand();

  void run({
    required RepositoryModel repository,
    required List<ImportReference> imports,
  }) {
    final report = DoctorService().analyze(
      repository: repository,
      imports: imports,
    );

    _printReport(report);
  }

  void _printReport(DoctorReport report) {
    print('');
    print('═══════════════════════════════════════');
    print('🏛 Atlas Engineering Doctor');
    print('═══════════════════════════════════════');
    print('');

    print('Repository');
    print('  Path       : ${report.repositoryPath}');
    print('  Files      : ${report.totalFiles}');
    print('  Dart files : ${report.dartFiles}');
    print('');

    print('Imports');
    print('  Local      : ${report.localImports}');
    print('  Package    : ${report.packageImports}');
    print('  Flutter    : ${report.flutterImports}');
    print('  Dart SDK   : ${report.dartSdkImports}');
    print('');

    print('Health Score');
    print('  ${report.healthScore}/100');
    print('');
  }
}
