import 'doctor_observation.dart';

class DoctorReport {
  const DoctorReport({
    required this.repositoryPath,
    required this.totalFiles,
    required this.dartFiles,
    required this.localImports,
    required this.packageImports,
    required this.flutterImports,
    required this.dartSdkImports,
    required this.healthScore,
    required this.observations,
  });

  final String repositoryPath;

  final int totalFiles;
  final int dartFiles;

  final int localImports;
  final int packageImports;
  final int flutterImports;
  final int dartSdkImports;

  final int healthScore;

  final List<DoctorObservation> observations;
}
