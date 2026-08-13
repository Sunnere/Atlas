class SnapshotProvenance {
  const SnapshotProvenance({
    required this.capturedAt,
    required this.sourcePath,
    required this.scannerVersion,
    this.gitCommit,
  });

  static const currentScannerVersion = '1.0.0';

  final DateTime capturedAt;
  final String sourcePath;
  final String scannerVersion;
  final String? gitCommit;
}
